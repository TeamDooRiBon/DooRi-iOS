//
//  TestChoiceViewController.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/12.
//

import UIKit

class TestChoiceViewController: UIViewController {

    @IBOutlet weak var answerCollectionView: UICollectionView!
    
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var indicatorBar: UIView!
    
    private var answerList: [AnswerDataModel] = []
    private lazy var answers: [Int] = Array(repeating: 0, count: answerList.count)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        
        serAnswerList()
        updateQuestion(0)
        answerCollectionView.delegate = self
        answerCollectionView.dataSource = self

        answerCollectionView.isScrollEnabled = false
    }

    @IBAction func previousButtonClicked(_ sender: Any) {
        guard let cell = answerCollectionView.visibleCells.first,
           let currentNumber = answerCollectionView.indexPath(for: cell)?.item else {
            return
        }
        let previousItem = max(currentNumber - 1, 0)
        answerCollectionView.scrollToItem(at: IndexPath(item: previousItem, section: 0), at: .left, animated: true)
        updateQuestion(previousItem)
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        guard let cell = answerCollectionView.visibleCells.first,
           let currentNumber = answerCollectionView.indexPath(for: cell)?.item else {
            return
        }
        let nextItem = min(currentNumber + 1, answerList.count - 1)
        answerCollectionView.scrollToItem(at: IndexPath(item: nextItem, section: 0), at: .left, animated: true)
        updateQuestion(nextItem)
    }
    
    @IBAction func outTestButtonClicked(_ sender: Any) {
        // FIXME: 공통 popup으로 바꾸세요.
        OutPopupView.loadFromXib()
            .setTitle("정말 나가시겠습니까?")
            .setDescription("""
                            지금까지의 응답 정보는 저장되지 않습니다.
                            테스트 중단을 원하신다면 오른쪽 버튼을 눌러주세요
                            """)
            .setCancelButton()
            .setConfirmButton()
            .present { event in
                if event == .confirm {
                    // confirm action
                }
            }
    }
    
    
    func serAnswerList()
    {
        answerList.append(contentsOf: [
            AnswerDataModel(answer1: "시간 단위로 세세하게 장소와 동선까지 정하고싶어", answer2: "지역이랑 숙소만 정하고 나머지는 여행 중에 정할래", answer3: "계획 없이 기분에 따라 발길 닿는대로 다니고 싶어", answer4: "함께 하는 사람들이 하자는 대로 할게"),
            AnswerDataModel(answer1: "이동 시간은 최대한 줄이고 관광을 더 하고 싶어", answer2: "천천히 이곳저곳 둘러보며 이동할래", answer3: "이동을 많이 하고싶지 않아. 움직이는게 싫어", answer4: "이동도 함께하면 즐거울거야. 무엇이든 상관없어"),
            AnswerDataModel(answer1: "최대한 많은 관광지를 둘러보고 싶어", answer2: "쉬엄쉬엄 여유롭게 구경 다니고 싶어", answer3: "관광보다는 편안한 곳에서 느긋하게 힐링하고 싶어", answer4: "같이 가는 사람들이 하자는 대로 할래"),
            AnswerDataModel(answer1: "당연히 풍경사진도, 내 인생샷도 열심히 찍어야지", answer2: "주변 사람한테 부탁해서 단체사진부터 찍고싶어", answer3: "함께 간 사람들의 사진을 찍어줄래", answer4: "사진을 찍기보다는 그 순간을 내 눈에 담고 싶어"),
            AnswerDataModel(answer1: "미리 다른 식당도 조사해 놓을거라 걱정없어", answer2: "다시 검색해서 검증된 식당을 갈래", answer3: "주변 사람들한테 맛있는 식당을 아는지 물어볼래", answer4: "그 근처에 괜찮아 보이는 식당으로 갈래"),
            AnswerDataModel(answer1: "사람이 붐비는 시끌벅적한 곳이야", answer2: "우리밖에 없는 한적하고 조용한 곳이야", answer3: "그날의 기분에 따라 달라질 것 같아", answer4: "다같이 있다면 장소의 분위기 상관없이 어디든 좋아"),
            AnswerDataModel(answer1: "나 혼자라도 다녀오고 싶어", answer2: "그룹 일정이 끝나고 혼자 다녀 올래", answer3: "다음을 기약하며 그곳을 포기하고 그룹이랑 다닐래", answer4: "그곳이 얼마나 좋은지 어필해서 그룹을 설득시킬래"),
            AnswerDataModel(answer1: "새로운 사람들과 즐겁게 대화를 이어 갈래", answer2: "다른 친구들이 대답하는 걸 지켜보고 있을거야", answer3: "내가 바로 먼저 말을 거는 그 사람이야!", answer4: "모르는 사람을 만나기보다는 우리끼리만 놀고 싶어"),
            AnswerDataModel(answer1: "그래도 계획한 만큼만 머물고 다음 장소로 이동할래", answer2: "다음 계획을 위해 떠나고 다른 날에 다시 방문할래", answer3: "기존 계획을 변경하더라도 그곳에 오래 있을래", answer4: "함께 하는 사람들의 의견을 따를래"),
            AnswerDataModel(answer1: "사람들이 많이 가는 유명한 장소 위주로 다닐래", answer2: "랜드마크 몇 군데만 가고 나머지는 마음대로 다닐래", answer3: "아무도 안 가본 새로운 장소를 찾아보고 싶어", answer4: "함께 하는 사람들이 가자는 대로 갈래")
        ])
    }

    func updateQuestion(_ currentNumber: Int) {
        self.questionNumberLabel.text = "Q\(currentNumber + 1)"
        // 질문 내용 변경
        switch currentNumber {
        case 0:
            self.questionLabel.text = "계획을 세울 때 나는?"
        case 1:
            self.questionLabel.text = "한 장소에서 다른 장소로 이동할 때 나는?"
        case 2:
            self.questionLabel.text = "내가 원하는 여행 스타일은"
        case 3:
            self.questionLabel.text = "멋진 풍경이 내 눈 앞에 펼쳐졌을 때 나는?"
        case 4:
            self.questionLabel.text = "가려고 했던 식당이 문을 닫았을 때 나는?"
        case 5:
            self.questionLabel.text = "내가 더 많은 시간을 보내고 싶은 곳은?"
        case 6:
            self.questionLabel.text = "일행과 서로 가고 싶은 곳이 다를 때는?"
        case 7:
            self.questionLabel.text = "일행과 서로 가고 싶은 곳이 다를 때는?"
        case 8:
            self.questionLabel.text = "다른 사람들이 말을 걸어왔을 때 나는?"
        case 9:
            self.questionLabel.text = "방문할 장소를 선택할 때 나는?"
        default:
            self.questionLabel.text = " "
        }
    }
    
    // MARK: - 컬렉션뷰 인덱스에 따른 변화
    // FIXME: MainViewController 처럼 바꾸기
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in answerCollectionView.visibleCells {
            if let row = answerCollectionView.indexPath(for: cell)?.item {
                
                // 인디케이터 바
                let totalWidth = backgroundView.frame.width
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
                    self.indicatorBar.frame.origin.x = totalWidth * (CGFloat(row)/10)
                }
            }
        }
    }
    
}

// MARK: - 익스텐션
extension TestChoiceViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return answerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let answerCell = collectionView.dequeueReusableCell(withReuseIdentifier: AnswerCollectionViewCell.identifier, for: indexPath) as? AnswerCollectionViewCell else { return UICollectionViewCell() }
        
        answerCell.setData(answer1: answerList[indexPath.row].answer1,
                           answer2: answerList[indexPath.row].answer2,
                           answer3: answerList[indexPath.row].answer3,
                           answer4: answerList[indexPath.row].answer4)
        
        return answerCell
    }
    
}

extension TestChoiceViewController: UICollectionViewDelegate
{
    
}

extension TestChoiceViewController: UICollectionViewDelegateFlowLayout
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

extension TestChoiceViewController: AnswerCollectionViewCellDelegate {
    func didSelectedAnswer(_ index: Int) {
        guard let cell = answerCollectionView.visibleCells.first,
              let currentNumber = answerCollectionView.indexPath(for: cell)?.item,
              currentNumber < answerList.count else {
            return
        }
        answers[currentNumber] = index
    }
}
