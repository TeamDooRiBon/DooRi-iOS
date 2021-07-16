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
    @IBOutlet weak var indicatorBarWidth: NSLayoutConstraint!
    
    var questionDataList: [StyleQuestionData] = []
    var testResult: StyleResultData?
    var mainTestResult: MainStyleTestResponse?
    private lazy var answers: [Int] = Array(repeating: -1, count: questionDataList.count)
    var thisID: String = ""
    var disMissCheck = false
    
// MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerCollectionView.delegate = self
        answerCollectionView.dataSource = self
        answerCollectionView.isScrollEnabled = false
        buttonChangeColor(isEnabled: false, isLast: false)
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
        buttonChangeColor(isEnabled: true, isLast: false)
    }
    
    // 다음 문항 버튼 클릭시
    @IBAction func nextButtonClicked(_ sender: Any) {
        guard let cell = answerCollectionView.visibleCells.first,
              let currentNumber = answerCollectionView.indexPath(for: cell)?.item else {
            return
        }

        guard currentNumber < questionDataList.count - 1 else {
            testResultSave()
            return
        }

        let nextItem = min(currentNumber + 1, questionDataList.count - 1)

        // 다음 질문이 미선택시에만 color 변경
        if answers[nextItem] == -1 {
            // currentNumber가 질문리스트보다 적으면 nextButton을 터치할 수 있도록 하면서 컬러도 변경
            buttonChangeColor(isEnabled: false, isLast: nextItem == questionDataList.count - 1)
        }

        answerCollectionView.scrollToItem(at: IndexPath(item: nextItem, section: 0), at: .left, animated: true)
        updateQuestion(nextItem)
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
                    if self.disMissCheck {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
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
                    questionDataList = titleContent.data!
                    answerCollectionView.reloadData()
                    updateQuestion(0)
                    indicatorBarWidth.constant = backgroundView.frame.width / CGFloat(questionDataList.count)
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
    
    func testResultSave() {
        let weightResult = getWeightResult()
        guard !weightResult.isEmpty else {
            return
        }
        let styleQuestionStoryboard = UIStoryboard(name: "StyleQuestionStoryboard", bundle: nil)
        let viewController = styleQuestionStoryboard.instantiateViewController(identifier: "StyleQuestionLoadingViewController")
        present(viewController, animated: true, completion: nil)
        
        if disMissCheck {
            print("함수 진입")
            MainStyleTestService.shared.getData(score: [10, 20, 30, 40, 50, 60, 70, 80]) { (response) in
                switch (response) {
                case .success(let data):
                    print("들어옴")
                    if let result = data as? MainStyleTestResponse {
                        self.mainTestResult = result
                        
                        // FIXME: 사실은 present가 완료되는 것보다 dismiss가 먼저 불릴 수도 있기 때문에 굉장히 위험한 방식. 앱잼시에만 사용합니다.
                        self.dismiss(animated: true) {
                            self.goToResultView(mainOrMember: true)
                        }
                    }
                case .requestErr(_):
                    print("requestErr")
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
                }
            }
        } else {
            StyleResultService.shared.resultSave(groupID: thisID, score: weightResult, choice: answers) { [weak self] (response) in
                switch (response) {
                case .success(let data):
                    if let result = data as? StyleResultResponse {
                        self?.testResult = result.data
                        
                        // FIXME: 사실은 present가 완료되는 것보다 dismiss가 먼저 불릴 수도 있기 때문에 굉장히 위험한 방식. 앱잼시에만 사용합니다.
                        self?.dismiss(animated: true) {
                            self?.goToResultView(mainOrMember: false)
                        }
                    }
                case .requestErr(_):
                    print("requestErr")
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
                }
            }
        }
    }

    func getWeightResult() -> [Int] {
        // answers에 -1이 아직 존재하면 계산하지 않음
        // -1이 존재한다는 것은 아직 선택안한 질문이 있다는 것
        guard !answers.contains(-1) else {
            return []
        }
        let weightResults = answers.enumerated().map { questionDataList[$0.offset].content[$0.element - 1].weight }
        let weightData = weightResults.reduce(Array(repeating: 0, count: weightResults.first?.count ?? 0)) { result, weight in
            result.enumerated().map { $0.element + weight[$0.offset] }
        }
        return weightData
    }
    
    func goToResultView(mainOrMember : Bool) {
        if mainOrMember {
            let testReusltStoryboard = UIStoryboard(name: "StyleTestResultStoryboard", bundle: nil)
            guard let nextVC = testReusltStoryboard.instantiateViewController(identifier: "StyleTestResultViewController") as? StyleTestResultViewController else { return }
            nextVC.name = mainTestResult?.data?.member ?? ""
            nextVC.imgURL = mainTestResult?.data?.iOSResultImage ?? ""
            nextVC.style = mainTestResult?.data?.title ?? ""
            nextVC.buttonText = "메인으로 이동"
            nextVC.mainOrMember = true
            nextVC.modalPresentationStyle = .overFullScreen
            self.present(nextVC, animated: true, completion: nil)
        } else {
            let testReusltStoryboard = UIStoryboard(name: "StyleTestResultStoryboard", bundle: nil)
            guard let nextVC = testReusltStoryboard.instantiateViewController(identifier: "StyleTestResultViewController") as? StyleTestResultViewController else { return }
            nextVC.name = testResult?.member ?? ""
            nextVC.imgURL = testResult?.iOSResultImage ?? ""
            nextVC.style = testResult?.title ?? ""
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }

    // 질문 내용 변경
    func updateQuestion(_ currentNumber: Int) {
        questionNumberLabel.text = "Q\(currentNumber + 1)"
        questionLabel.text = questionDataList[currentNumber].title
    }

    // 인디케이터 바
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.indicatorBar.frame.origin.x = scrollView.contentOffset.x / CGFloat(questionDataList.count)
    }
    
    // 다음 문항 버튼 색상 변경
    func buttonChangeColor(isEnabled: Bool, isLast: Bool) {
        nextButton.isEnabled = isEnabled
        nextButton.backgroundColor = isEnabled ? Colors.pointOrange.color : Colors.gray7.color
        nextButton.setTitleColor(isEnabled ? Colors.white9.color : Colors.gray4.color, for: .normal)

        // 마지막 버튼 이름 바꾸기
        if isLast {
            nextButton.setTitle("결과 보러가기", for: .normal)
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

        let questionContentList = questionDataList[indexPath.item].content
        answerCell.setData(answers: questionContentList,
                           answerNumber: answers[indexPath.item])
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
        answers[currentNumber] = index + 1

        // 질문을 선택하면 컬러 변경
        buttonChangeColor(isEnabled: true, isLast: currentNumber == questionDataList.count - 1)
    }
}
