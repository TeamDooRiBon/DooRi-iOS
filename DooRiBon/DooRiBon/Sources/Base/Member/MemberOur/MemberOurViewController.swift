//
//  MemberOurViewController.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/09.
//

import UIKit

class MemberOurViewController: UIViewController {

    
    @IBOutlet weak var memberOurTableView: UITableView!
    var memberList: [MemberOurTableViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSet()
        memberListSet()
    }
    
    func tableViewSet() {
        memberOurTableView.delegate = self
        memberOurTableView.dataSource = self
//        let nibName = UINib(nibName: "MyTableViewCell", bundle: nil)
//        memberOurTableView.register(nibName, forCellReuseIdentifier: "MyTableViewCell")
        let nibName = UINib(nibName: "MemberSelfTableViewCell", bundle: nil)
        memberOurTableView.register(nibName, forCellReuseIdentifier: "MemberSelfTableViewCell")
    }
    
    func memberListSet() {
        memberList.append(contentsOf: [
            MemberOurTableViewModel(name: "유지인", type: "test", styleOne: "test", styleTwo: "test", styleThree: "test"),
            MemberOurTableViewModel(name: "김인우", type: "test", styleOne: "test", styleTwo: "test", styleThree: "test"),
            MemberOurTableViewModel(name: "박유진", type: "test", styleOne: "test", styleTwo: "test", styleThree: "test")
        ])
    }

}

extension MemberOurViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return memberList.count
        default:
            return 0
        }
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 0:
//            return "나의 여행 유형"
//        case 1:
//            return "함께하는 멤버들의 여행 유형"
//        default:
//            return ""
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 26
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 113
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemberOurTableViewCell", for: indexPath) as? MemberOurTableViewCell else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            cell.memberName.text = "한상진"
            cell.memberType.text = "test"
            cell.memberStyleOne.text = "test"
            cell.memberStyleTwo.text = "test"
            cell.memberStyleThree.text = "test"
            return cell
        case 1:
            cell.memberType.text = memberList[indexPath.row].memberType
            cell.memberName.text = memberList[indexPath.row].memberName
            cell.memberStyleOne.text = memberList[indexPath.row].memberStyleOne
            cell.memberStyleTwo.text = memberList[indexPath.row].memberStyleTwo
            cell.memberStyleThree.text = memberList[indexPath.row].memberStyleThree
            return cell
        default:
            return UITableViewCell()
        }
    }
}
