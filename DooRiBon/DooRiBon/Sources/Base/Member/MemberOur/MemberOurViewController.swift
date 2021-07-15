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
    
//    var memberStyleList: [MemberOurTableViewModel] = []
//    var myStyleList: [MemberOurTableViewModel] = []
    var tripData: Group?
    private var myStyleData: TripTendencyDataModel?
    private var memberStyleData: [TripTendencyDataModel] = []
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirstData()
        myStyleListSet()
        memberStyleListSet()
        tableViewSet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getStyleData()
    }
    
    //MARK:- Function
    
    func tableViewSet() {
        memberOurTableView.delegate = self
        memberOurTableView.dataSource = self
        memberOurTableView.register(NibConstants.MemberStartViewNib, forCellReuseIdentifier: "MemberStartView")
        memberOurTableView.register(NibConstants.MemberStartNib, forCellReuseIdentifier: "MemberStartTableViewCell")
        memberOurTableView.register(NibConstants.MemberCodeCopyNib, forCellReuseIdentifier: "MemberCodeCopyTableViewCell")
        memberOurTableView.backgroundColor = .clear
    }
    
    private func getStyleData() {
        guard let groupId = tripData?._id else { return }
        GetMemberStyleDataService.shared.getMemberStyle(groupId: groupId)
        { [self] (response) in
            
            switch response {
            case .success(let data):
                if let style = data as? DivisionMemberDataModel {
                    myStyleData = style.myResult
                    memberStyleData = style.othersResult
                    memberOurTableView.reloadData()
                }
            case .requestErr(_):
                print("requestErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            case .pathErr:
                print("pathErr")
            }
        }
    }
    
    func myStyleListSet() {
//        myStyleList.append(contentsOf: [
//            MemberOurTableViewModel(name: "한상진", type: "철두철미 계획가", styleOne: "계획도장깨기", styleTwo: "여행리더", styleThree: "어깨으쓱")
//        ])
    }
    
    func memberStyleListSet() {
//        memberStyleList.append(contentsOf: [
//            MemberOurTableViewModel(name: "유지인", type: "test", styleOne: "test", styleTwo: "test", styleThree: "test"),
//            MemberOurTableViewModel(name: "김인우", type: "test", styleOne: "test", styleTwo: "test", styleThree: "test"),
//            MemberOurTableViewModel(name: "박유진", type: "test", styleOne: "test", styleTwo: "test", styleThree: "test")
//        ])
    }
    
}

//MARK:- Extension

extension MemberOurViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if memberStyleData.count != 0 {
            switch section {
            case 0:
                return 1
            case 1:
                return memberStyleData.count
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
            headerView.memberHeaderButton.isHidden = myStyleData == nil
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
        if myStyleData != nil {
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
            if myStyleData != nil {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemberOurTableViewCell", for: indexPath) as? MemberOurTableViewCell else { return UITableViewCell() }
                cell.memberType.text = myStyleData?.title
                cell.memberName.text = myStyleData?.member.name
                cell.memberStyleOne.text = myStyleData?.tag[0]
                cell.memberStyleTwo.text = myStyleData?.tag[1]
                cell.memberStyleThree.text = myStyleData?.tag[2]
                cell.selectionStyle = .none
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemberStartTableViewCell", for: indexPath) as? MemberStartTableViewCell else { return UITableViewCell() }
                cell.delegate = self
                return cell
            }
        case 1:
            if memberStyleData.count != 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemberOurTableViewCell", for: indexPath) as? MemberOurTableViewCell else { return UITableViewCell() }
                cell.memberType.text = memberStyleData[indexPath.row].title
                cell.memberName.text = memberStyleData[indexPath.row].member.name
                cell.memberStyleOne.text = memberStyleData[indexPath.row].tag[0]
                cell.memberStyleTwo.text = memberStyleData[indexPath.row].tag[1]
                cell.memberStyleThree.text = memberStyleData[indexPath.row].tag[2]
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
extension MemberOurViewController: goToTestViewProtocol {
    func goToTestView() {
        let styleQuestionStoryboard = UIStoryboard(name: "StyleQuestionStoryboard", bundle: nil)
        guard let nextVC = styleQuestionStoryboard.instantiateViewController(identifier: "StyleQuestionViewController") as? StyleQuestionViewController else { return }
        nextVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
extension MemberOurViewController {
    private func setupFirstData() {
        guard let model = (self.tabBarController as! TripViewController).tripData else { return }
        tripData = model
    }
}
