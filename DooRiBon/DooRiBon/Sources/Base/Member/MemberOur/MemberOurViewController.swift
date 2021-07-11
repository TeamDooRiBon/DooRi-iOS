//
//  MemberOurViewController.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/09.
//

import UIKit

class MemberOurViewController: UIViewController, PageComponentProtocol {
    var pageTitle: String = "우리들"

    //MARK:- IBOutlet
    
    @IBOutlet weak var memberOurTableView: UITableView!
    
    //MARK:- Variable
    
    var memberStyleList: [MemberOurTableViewModel] = []
    var myStyleList: [MemberOurTableViewModel] = []
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myStyleListSet()
        memberStyleListSet()
        tableViewSet()
    }
    
    //MARK:- Function
    
    func tableViewSet() {
        memberOurTableView.delegate = self
        memberOurTableView.dataSource = self
        var nibName = UINib(nibName: "MemberStartView", bundle: nil)
        memberOurTableView.register(nibName, forCellReuseIdentifier: "MemberStartView")
        memberOurTableView.backgroundColor = .clear
        nibName = UINib(nibName: "MemberStart", bundle: nil)
        memberOurTableView.register(nibName, forCellReuseIdentifier: "MemberStartTableViewCell")
        nibName = UINib(nibName: "MemberCodeCopy", bundle: nil)
        memberOurTableView.register(nibName, forCellReuseIdentifier: "MemberCodeCopyTableViewCell")
    }
    
    func myStyleListSet() {
        myStyleList.append(contentsOf: [
            MemberOurTableViewModel(name: "한상진", type: "철두철미 계획가", styleOne: "계획도장깨기", styleTwo: "여행리더", styleThree: "어깨으쓱")
        ])
    }
    
    func memberStyleListSet() {
        memberStyleList.append(contentsOf: [
            MemberOurTableViewModel(name: "유지인", type: "test", styleOne: "test", styleTwo: "test", styleThree: "test"),
            MemberOurTableViewModel(name: "김인우", type: "test", styleOne: "test", styleTwo: "test", styleThree: "test"),
            MemberOurTableViewModel(name: "박유진", type: "test", styleOne: "test", styleTwo: "test", styleThree: "test")
        ])
    }
    
}

//MARK:- Extension

extension MemberOurViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if memberStyleList.count != 0 {
            switch section {
            case 0:
                return myStyleList.count
            case 1:
                return memberStyleList.count
            default:
                return 0
            }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = MemberHeaderView.loadFromXib()
        switch section {
        case 0:
            headerView.memberHeaderLabel.text = "나의 여행 유형"
            headerView.memberHeaderLabel.font = UIFont.SpoqaHanSansNeo(.bold, size: 16)
            headerView.memberHeaderLabel.textColor = Colors.black2.color
            if myStyleList.count == 0 {
                headerView.memberHeaderButton.isHidden = true
            } else {
                headerView.memberHeaderButton.isHidden = false
            }
        case 1:
            headerView.memberHeaderLabel.text = "함께하는 멤버들의 여행 유형"
            headerView.memberHeaderLabel.font = UIFont.SpoqaHanSansNeo(.bold, size: 16)
            headerView.memberHeaderLabel.textColor = Colors.black2.color
            headerView.memberHeaderButton.isHidden = true
        default:
            return UIView()
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if myStyleList.count != 0 {
            return 113
        } else {
            switch indexPath.section {
            case 0:
                return 226
            case 1:
                return 123
            default:
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if myStyleList.count != 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemberOurTableViewCell", for: indexPath) as? MemberOurTableViewCell else { return UITableViewCell() }
                cell.memberType.text = myStyleList[indexPath.row].memberType
                cell.memberName.text = myStyleList[indexPath.row].memberName
                cell.memberStyleOne.text = myStyleList[indexPath.row].memberStyleOne
                cell.memberStyleTwo.text = myStyleList[indexPath.row].memberStyleTwo
                cell.memberStyleThree.text = myStyleList[indexPath.row].memberStyleThree
                cell.selectionStyle = .none
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemberStartTableViewCell", for: indexPath) as? MemberStartTableViewCell else { return UITableViewCell() }
                return cell
            }
        case 1:
            if memberStyleList.count != 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemberOurTableViewCell", for: indexPath) as? MemberOurTableViewCell else { return UITableViewCell() }
                cell.memberType.text = memberStyleList[indexPath.row].memberType
                cell.memberName.text = memberStyleList[indexPath.row].memberName
                cell.memberStyleOne.text = memberStyleList[indexPath.row].memberStyleOne
                cell.memberStyleTwo.text = memberStyleList[indexPath.row].memberStyleTwo
                cell.memberStyleThree.text = memberStyleList[indexPath.row].memberStyleThree
                cell.selectionStyle = .none
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCodeCopyTableViewCell", for: indexPath) as? MemberCodeCopyTableViewCell else { return UITableViewCell() }
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
}
