//
//  MemberOurViewController.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/09.
//

import UIKit
import Kingfisher

class MemberOurViewController: UIViewController, PageComponentProtocol {
    var pageTitle: String = "우리들"

    //MARK:- IBOutlet
    
    @IBOutlet weak var memberOurTableView: UITableView!
    
    //MARK:- Variable
    
    var tripData: Group?
    private var myStyleData: TripTendencyDataModel?
    private var memberStyleData: [TripTendencyDataModel] = []
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirstData()
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
    
}

//MARK:- Extension

extension MemberOurViewController: UITableViewDelegate, UITableViewDataSource, MemberTableCellDelegate {
    func didDetailLookButtonTapppd(for cell: MemberOurTableViewCell) {
        let indexPath = cell.indexPath
        if indexPath?.section == 0 {
            if myStyleData != nil {
                let testReusltStoryboard = UIStoryboard(name: "StyleTestResultStoryboard", bundle: nil)
                guard let nextVC = testReusltStoryboard.instantiateViewController(identifier: "StyleTestResultViewController") as? StyleTestResultViewController else { return }
                nextVC.name = myStyleData?.member.name ?? ""
                nextVC.imgURL = myStyleData?.iOSResultImage ?? ""
                nextVC.style = myStyleData?.title ?? ""
                nextVC.fromOurView = true
                nextVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        } else {
            if memberStyleData.count != 0 {
                let testReusltStoryboard = UIStoryboard(name: "StyleTestResultStoryboard", bundle: nil)
                guard let nextVC = testReusltStoryboard.instantiateViewController(identifier: "StyleTestResultViewController") as? StyleTestResultViewController else { return }
                nextVC.name = memberStyleData[indexPath?.row ?? 0].member.name
                nextVC.imgURL = memberStyleData[indexPath?.row ?? 0].iOSResultImage
                nextVC.style = memberStyleData[indexPath?.row ?? 0].title
                nextVC.fromOurView = true
                nextVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if memberStyleData.count == 0 {
                return 1
            } else {
                return memberStyleData.count
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = MemberHeaderView.loadFromXib()
        switch section {
        case 0:
            headerView.memberHeaderLabel.text = "나의 여행 유형"
            headerView.memberHeaderLabel.font = UIFont.SpoqaHanSansNeo(.bold, size: 16)
            headerView.memberHeaderLabel.textColor = Colors.black2.color
        case 1:
            headerView.memberHeaderLabel.text = "함께하는 멤버들의 여행 유형"
            headerView.memberHeaderLabel.font = UIFont.SpoqaHanSansNeo(.bold, size: 16)
            headerView.memberHeaderLabel.textColor = Colors.black2.color
        default:
            return UIView()
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if myStyleData != nil {
                return 113
            } else {
                return 226
            }
        case 1:
            if memberStyleData.count != 0 {
                return 113
            } else {
                return 120
            }
        default:
            return 0
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
                cell.memberThumbNailImage.kf.setImage(with: URL(string: myStyleData?.thumbnail ?? ""))
                cell.selectionStyle = .none
                cell.delegate = self
                cell.indexPath = indexPath
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
                cell.memberThumbNailImage.kf.setImage(with: URL(string: memberStyleData[indexPath.row].thumbnail))
                cell.selectionStyle = .none
                cell.delegate = self
                cell.indexPath = indexPath
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCodeCopyTableViewCell", for: indexPath) as? MemberCodeCopyTableViewCell else { return UITableViewCell() }
                cell.groupID = tripData?._id ?? ""
                return cell
            }
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if myStyleData != nil {
                let testReusltStoryboard = UIStoryboard(name: "StyleTestResultStoryboard", bundle: nil)
                guard let nextVC = testReusltStoryboard.instantiateViewController(identifier: "StyleTestResultViewController") as? StyleTestResultViewController else { return }
                nextVC.name = myStyleData?.member.name ?? ""
                nextVC.imgURL = myStyleData?.iOSResultImage ?? ""
                nextVC.style = myStyleData?.title ?? ""
                nextVC.fromOurView = true
                nextVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        } else {
            if memberStyleData.count != 0 {
                let testReusltStoryboard = UIStoryboard(name: "StyleTestResultStoryboard", bundle: nil)
                guard let nextVC = testReusltStoryboard.instantiateViewController(identifier: "StyleTestResultViewController") as? StyleTestResultViewController else { return }
                nextVC.name = memberStyleData[indexPath.row].member.name
                nextVC.imgURL = memberStyleData[indexPath.row].iOSResultImage
                nextVC.style = memberStyleData[indexPath.row].title
                nextVC.fromOurView = true
                nextVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
}
extension MemberOurViewController: goToTestViewProtocol {
    func goToTestView() {
        let styleQuestionStoryboard = UIStoryboard(name: "StyleQuestionStoryboard", bundle: nil)
        guard let nextVC = styleQuestionStoryboard.instantiateViewController(identifier: "StyleQuestionViewController") as? StyleQuestionViewController else { return }
        nextVC.hidesBottomBarWhenPushed = true
        nextVC.thisID = tripData?._id ?? ""
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
extension MemberOurViewController {
    enum UserState {
        case my
        case you
    }
    
    private func setupFirstData() {
        guard let model = (self.tabBarController as! TripViewController).tripData else { return }
        tripData = model
    }
}
