//
//  TestChoiceViewController.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/12.
//

import UIKit

class StyleQuestionViewController: UIViewController {
    // 컬렉션 뷰
    @IBOutlet weak var answerCollectionView: UICollectionView!
    // 라벨
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    // 뷰
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var indicatorBar: UIView!
    
    var questionDataList: [StyleQuestionData] = []
    var questionAnswerWeightList: [StyleQuestionAnswerWeight] = []
    private lazy var weightResult: [Int] = Array(repeating: 0, count: 8)
    private lazy var answers: [Int] = Array(repeating: -1, count: questionDataList.count)
    var selectedWeight: [Int] = []
    
    
// MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerCollectionView.delegate = self
        answerCollectionView.dataSource = self
        answerCollectionView.isScrollEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        questionDataListSet()
    }
    
// MARK: - 버튼

    // 이전 문항 버튼 클릭시
    @IBAction func previousButtonClicked(_ sender: Any) {
        guard let cell = answerCollectionView.visibleCells.first,
           let currentNumber = answerCollectionView.indexPath(for: cell)?.item else {
            return
        }
        let previousItem = max(currentNumber - 1, 0)
        answerCollectionView.scrollToItem(at: IndexPath(item: previousItem, section: 0), at: .left, animated: true)
        updateQuestion(previousItem)
        for i in Range(0...7) {
            weightResult[i] -= selectedWeight[i]
        }
        print("가중치 합 : \(weightResult)")
    }
    
    // 다음 문항 버튼 클릭시
    @IBAction func nextButtonClicked(_ sender: Any) {
        guard let cell = answerCollectionView.visibleCells.first,
              let currentNumber = answerCollectionView.indexPath(for: cell)?.item, currentNumber < questionDataList.count else {
            return
        }
        // 4개 중 1개를 선택할때만 버튼을 작동시킴
        if (answers[currentNumber] != -1) {
            guard let cell = answerCollectionView.visibleCells.first,
                  let currentNumber = answerCollectionView.indexPath(for: cell)?.item else {
                return
            }
            nextButton.backgroundColor = Colors.gray7.color
            nextButton.setTitleColor(Colors.gray4.color, for: .normal)

            let nextItem = min(currentNumber + 1, questionDataList.count - 1)
            answerCollectionView.scrollToItem(at: IndexPath(item: nextItem, section: 0), at: .left, animated: true)
            updateQuestion(nextItem)
        }
        for i in Range(0...7) {
            weightResult[i] += selectedWeight[i]
        }
        print("가중치 합 : \(weightResult)")
        // 마지막 버튼 이름 바꾸기
        if (currentNumber == 8) {
            nextButton.setTitle("결과 보러가기", for: .normal)
        }
    }
    
    // 상단 x버튼 클릭 시
    @IBAction func outTestButtonClicked(_ sender: Any) {
        PopupView.loadFromXib()
            .setTitle("정말 나가시겠습니까?")
            .setDescription("""
                            지금까지의 응답 정보는 저장되지 않습니다.
                            테스트 중단을 원하신다면 오른쪽 버튼을 눌러주세요
                            """)
            .setCancelButton("계속할게요")
            .setConfirmButton("나갈게요")
            .present { event in
                if event == .confirm {
                    // confirm action
                }
            }
    }
    
    // MARK: - 함수
    
    func questionDataListSet() {
        StyleTestService.shared.getData { [self] (response) in
            switch(response)
            {
            case .success(let data):
                if let titleContent = data as? StyleQuestionResponse {
                    questionDataList = titleContent.data
                    answerCollectionView.reloadData()
                    updateQuestion(0)
                }
            case .requestErr(let message):
                print("requestERR", message)
            case .pathErr:
                print("pathERR")
            case .serverErr:
                print("serverERR")
            case .networkFail:
                print("networkERR")
            }
        }
    }

    // 질문 내용 변경
    func updateQuestion(_ currentNumber: Int) {
        questionNumberLabel.text = "Q\(currentNumber + 1)"
        questionLabel.text = questionDataList[currentNumber].title
        questionAnswerWeightList = questionDataList[currentNumber].content
    }

    // 인디케이터 바
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.indicatorBar.frame.origin.x = scrollView.contentOffset.x/10
    }
    
    // 다음 문항 버튼 색상 변경
    func buttonChangeColor() {
        guard let cell = answerCollectionView.visibleCells.first,
              let currentNumber = answerCollectionView.indexPath(for: cell)?.item,
              currentNumber < questionDataList.count else {
            return
        }

        if (answers[currentNumber] == 0 || answers[currentNumber] == 1 ||
            answers[currentNumber] == 2 || answers[currentNumber] == 3) {
            nextButton.backgroundColor = Colors.pointOrange.color
            nextButton.setTitleColor(Colors.white9.color, for: .normal)
        }
    }

}

// MARK: - 익스텐션
extension StyleQuestionViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let answerCell = collectionView.dequeueReusableCell(withReuseIdentifier: AnswerCollectionViewCell.identifier, for: indexPath) as? AnswerCollectionViewCell else { return UICollectionViewCell() }
        answerCell.delegate = self
        answerCell.setData(answer1: questionAnswerWeightList[0].answer,
                           answer2: questionAnswerWeightList[1].answer,
                           answer3: questionAnswerWeightList[2].answer,
                           answer4: questionAnswerWeightList[3].answer)
        
        return answerCell
    }
    
}

extension StyleQuestionViewController: UICollectionViewDelegate
{

}

extension StyleQuestionViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width      // 현재 사용하는 기기의 width를 가져와서 저장
        
        let cellWidth = width - 18 * 2
        let cellHeight = cellWidth * (240/339)        // 제플린에서의 비율만큼 곱해서 height를 결정

        return CGSize(width: cellWidth, height: cellHeight)     // 정해진 가로/세로를 CGSize형으로 return
    }
    
    // ContentInset 메서드: Cell에서 Content 외부에 존재하는 Inset의 크기를 결정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero    //  Inset을 사용하지 않는다는 뜻
    }
    
    // minimumLineSpacing 메서드: Cell 들의 위, 아래 간격 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // minimumInteritemSpacing 메서드: Cell 들의 좌,우 간격 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 36
    }
    
}

extension StyleQuestionViewController: AnswerCollectionViewCellDelegate {
    func didSelectedAnswer(_ index: Int) {
        
        guard let cell = answerCollectionView.visibleCells.first,
              let currentNumber = answerCollectionView.indexPath(for: cell)?.item,
              currentNumber < questionDataList.count else {
            return
        }
        answers[currentNumber] = index
        buttonChangeColor()
        selectedWeight = questionAnswerWeightList[index].weight
    }
}
