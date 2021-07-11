//
//  TakeLookViewController.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/10.
//

import UIKit

class TakeLookViewController: UIViewController, PageComponentProtocol, HeaderViewDelegate {
    
    var pageTitle: String = "살펴보기"
    var isOpen = [false, false, false, false, false, false, false, false, false, false]
    let numberList: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    let questionList: [String] = ["계획을 세울 때 나는?",
                                  "한 장소에서 다른 장소로 이동할 때 나는?",
                                  "내가 원하는 여행 스타일은?",
                                  "멋진 풍경이 내 눈 앞에 펼쳐졌을 때 나는?",
                                  "가려고 했던 식당이 문을 닫았을 때 나는?",
                                  "내가 더 많은 시간을 보내고 싶은 곳은?",
                                  "일행과 서로 가고 싶은 곳이 다를 때는?",
                                  "다른 사람들이 말을 걸어왔을 때 나는?",
                                  "방문한 장소가 마음에 들 때 나는?",
                                  "방문할 장소를 선택할 때 나는?"]
    
    @IBOutlet weak var questionHeaderView: UIView!
    @IBOutlet weak var styleQuestionTableView: UITableView!
    
    var optionList0: [styleQuestionListDataModel] = []
    var optionList1: [styleQuestionListDataModel] = []
    var optionList2: [styleQuestionListDataModel] = []
    var optionList3: [styleQuestionListDataModel] = []
    var optionList4: [styleQuestionListDataModel] = []
    var optionList5: [styleQuestionListDataModel] = []
    var optionList6: [styleQuestionListDataModel] = []
    var optionList7: [styleQuestionListDataModel] = []
    var optionList8: [styleQuestionListDataModel] = []
    var optionList9: [styleQuestionListDataModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleQuestionTableView.tableHeaderView = questionHeaderView
        
        setOptionList()
        
        styleQuestionTableView.delegate = self
        styleQuestionTableView.dataSource = self
        
        styleQuestionTableView.register(UINib(nibName: "QuestionCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "QuestionCell")
        
        
    }
    
    func setOptionList()
    {
        optionList0.append(contentsOf: [
            styleQuestionListDataModel(number: "1", question: "시간 단위로 세세하게 장소와 동선까지 정하고싶어", count: "3명"),
            styleQuestionListDataModel(number: "2", question: "지역이랑 숙소만 정하고 나머지는 여행 중에 정할래", count: "3명"),
            styleQuestionListDataModel(number: "3", question: "계획 없이 기분에 따라 발길 닿는대로 다니고 싶어", count: "3명"),
            styleQuestionListDataModel(number: "4", question: "함께 하는 사람들이 하자는 대로 할게", count: "3명")
        ])
        optionList1.append(contentsOf: [
            styleQuestionListDataModel(number: "1", question: "이동 시간은 최대한 줄이고 관광을 더 하고 싶어", count: "3명"),
            styleQuestionListDataModel(number: "2", question: "천천히 이곳저곳 둘러보며 이동할래", count: "3명"),
            styleQuestionListDataModel(number: "3", question: "이동을 많이 하고싶지 않아. 움직이는게 싫어", count: "3명"),
            styleQuestionListDataModel(number: "4", question: "이동도 함께하면 즐거울거야. 무엇이든 상관없어", count: "3명")
        ])
        optionList2.append(contentsOf: [
            styleQuestionListDataModel(number: "1", question: "최대한 많은 관광지를 둘러보고 싶어", count: "3명"),
            styleQuestionListDataModel(number: "2", question: "쉬엄쉬엄 여유롭게 구경 다니고 싶어", count: "3명"),
            styleQuestionListDataModel(number: "3", question: "관광보다는 편안한 곳에서 느긋하게 힐링하고 싶어", count: "3명"),
            styleQuestionListDataModel(number: "4", question: "같이 가는 사람들이 하자는 대로 할래", count: "3명")
        ])
        optionList3.append(contentsOf: [
            styleQuestionListDataModel(number: "1", question: "당연히 풍경사진도, 내 인생샷도 열심히 찍어야지", count: "3명"),
            styleQuestionListDataModel(number: "2", question: "주변 사람한테 부탁해서 단체사진부터 찍고싶어", count: "3명"),
            styleQuestionListDataModel(number: "3", question: "함께 간 사람들의 사진을 찍어줄래", count: "3명"),
            styleQuestionListDataModel(number: "4", question: "사진을 찍기보다는 그 순간을 내 눈에 담고 싶어", count: "3명")
        ])
        optionList4.append(contentsOf: [
            styleQuestionListDataModel(number: "1", question: "미리 다른 식당도 조사해 놓을거라 걱정없어", count: "3명"),
            styleQuestionListDataModel(number: "2", question: "다시 검색해서 검증된 식당을 갈래", count: "3명"),
            styleQuestionListDataModel(number: "3", question: "주변 사람들한테 맛있는 식당을 아는지 물어볼래", count: "3명"),
            styleQuestionListDataModel(number: "4", question: "그 근처에 괜찮아 보이는 식당으로 갈래", count: "3명")
        ])
        optionList5.append(contentsOf: [
            styleQuestionListDataModel(number: "1", question: "사람이 붐비는 시끌벅적한 곳이야", count: "3명"),
            styleQuestionListDataModel(number: "2", question: "우리밖에 없는 한적하고 조용한 곳이야", count: "3명"),
            styleQuestionListDataModel(number: "3", question: "그날의 기분에 따라 달라질 것 같아", count: "3명"),
            styleQuestionListDataModel(number: "4", question: "다같이 있다면 장소의 분위기 상관없이 어디든 좋아", count: "3명")
        ])
        optionList6.append(contentsOf: [
            styleQuestionListDataModel(number: "1", question: "나 혼자라도 다녀오고 싶어", count: "3명"),
            styleQuestionListDataModel(number: "2", question: "그룹 일정이 끝나고 혼자 다녀 올래", count: "3명"),
            styleQuestionListDataModel(number: "3", question: "다음을 기약하며 그곳을 포기하고 그룹이랑 다닐래", count: "3명"),
            styleQuestionListDataModel(number: "4", question: "그곳이 얼마나 좋은지 어필해서 그룹을 설득시킬래", count: "3명")
        ])
        optionList7.append(contentsOf: [
            styleQuestionListDataModel(number: "1", question: "새로운 사람들과 즐겁게 대화를 이어 갈래", count: "3명"),
            styleQuestionListDataModel(number: "2", question: "다른 친구들이 대답하는 걸 지켜보고 있을거야", count: "3명"),
            styleQuestionListDataModel(number: "3", question: "내가 바로 먼저 말을 거는 그 사람이야!", count: "3명"),
            styleQuestionListDataModel(number: "4", question: "모르는 사람을 만나기보다는 우리끼리만 놀고 싶어", count: "3명")
        ])
        optionList8.append(contentsOf: [
            styleQuestionListDataModel(number: "1", question: "그래도 계획한 만큼만 머물고 다음 장소로 이동할래", count: "3명"),
            styleQuestionListDataModel(number: "2", question: "다음 계획을 위해 떠나고 다른 날에 다시 방문할래", count: "3명"),
            styleQuestionListDataModel(number: "3", question: "기존 계획을 변경하더라도 그곳에 오래 있을래", count: "3명"),
            styleQuestionListDataModel(number: "4", question: "함께 하는 사람들의 의견을 따를래", count: "3명")
        ])
        optionList9.append(contentsOf: [
            styleQuestionListDataModel(number: "1", question: "사람들이 많이 가는 유명한 장소 위주로 다닐래 ", count: "3명"),
            styleQuestionListDataModel(number: "2", question: "랜드마크 몇 군데만 가고 나머지는 마음대로 다닐래", count: "3명"),
            styleQuestionListDataModel(number: "3", question: "아무도 안 가본 새로운 장소를 찾아보고 싶어", count: "3명"),
            styleQuestionListDataModel(number: "4", question: "함께 하는 사람들이 가자는 대로 갈래", count: "3명")
        ])
    }
    
    func didTouchSection(_ sectionIndex: Int) {
        self.isOpen[sectionIndex].toggle()
        self.styleQuestionTableView.reloadData()
        
    }
}




extension TakeLookViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension TakeLookViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isOpen[section] == true {
            return optionList0.count
        }
        else {
            return 0
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let optionCell = tableView.dequeueReusableCell(withIdentifier: StyleQuestionTableViewCell.identifier, for: indexPath) as? StyleQuestionTableViewCell else { return UITableViewCell() }
        
        if (indexPath.section == 0) {
            optionCell.setdata(number: optionList0[indexPath.row].number,
                               question: optionList0[indexPath.row].question,
                               count: optionList0[indexPath.row].count)
        }
        if (indexPath.section == 1) {
            optionCell.setdata(number: optionList1[indexPath.row].number,
                               question: optionList1[indexPath.row].question,
                               count: optionList1[indexPath.row].count)
        }
        if (indexPath.section == 2) {
            optionCell.setdata(number: optionList2[indexPath.row].number,
                               question: optionList2[indexPath.row].question,
                               count: optionList2[indexPath.row].count)
        }
        if (indexPath.section == 3) {
            optionCell.setdata(number: optionList3[indexPath.row].number,
                               question: optionList3[indexPath.row].question,
                               count: optionList3[indexPath.row].count)
        }
        if (indexPath.section == 4) {
            optionCell.setdata(number: optionList4[indexPath.row].number,
                               question: optionList4[indexPath.row].question,
                               count: optionList4[indexPath.row].count)
        }
        if (indexPath.section == 5) {
            optionCell.setdata(number: optionList5[indexPath.row].number,
                               question: optionList5[indexPath.row].question,
                               count: optionList5[indexPath.row].count)
        }
        if (indexPath.section == 6) {
            optionCell.setdata(number: optionList6[indexPath.row].number,
                               question: optionList6[indexPath.row].question,
                               count: optionList6[indexPath.row].count)
        }
        if (indexPath.section == 7) {
            optionCell.setdata(number: optionList7[indexPath.row].number,
                               question: optionList7[indexPath.row].question,
                               count: optionList7[indexPath.row].count)
        }
        if (indexPath.section == 8) {
            optionCell.setdata(number: optionList8[indexPath.row].number,
                               question: optionList8[indexPath.row].question,
                               count: optionList8[indexPath.row].count)
        }
        if (indexPath.section == 9) {
            optionCell.setdata(number: optionList9[indexPath.row].number,
                               question: optionList9[indexPath.row].question,
                               count: optionList9[indexPath.row].count)
        }
        
        return optionCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 62
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "QuestionCell") as? QuestionCell else { return UITableViewHeaderFooterView() }
        
        headerView.backgroundColor = .white
        
        headerView.sectionIndex = section   // 섹션의 인덱스 값을 담아두기
        headerView.numberLabel.text = numberList[section]
        headerView.questionTitleLabel.text = questionList[section]
        
        headerView.delegate = self
        
        return headerView
    }
    

}
