//
//  PagerTabSampleViewController.swift
//  PagerTab
//
//  Created by 민 on 2021/07/06.
//

import UIKit

class MemberViewController: UIViewController {

    @IBOutlet weak var pagerTab: PagerTab!
    @IBOutlet private var topView: TripTopView!
    
    // MARK: - Properties
    var tripData: Group?
    static var thisID: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let vc1 = UIStoryboard(name: "MemberOurStoryboard", bundle: nil).instantiateViewController(identifier: "MemberOurViewController") as? MemberOurViewController else { return }
        guard let vc2 = UIStoryboard(name: "TakeLookStoryboard", bundle: nil).instantiateViewController(identifier: "TakeLookViewController") as? TakeLookViewController else { return }
        
        let viewControllers: [PageComponentProtocol] = [
            vc1,
            vc2
        ]
       
        var style = PagerTab.Style.default
        style.titleActiveColor = UIColor.orange
        style.barColor = UIColor.orange
        pagerTab.setup(self, viewControllers: viewControllers, style: style)
        // 상단영역 버튼 액션 연결
        setupButtonAction()
        setupFirstData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        refreshTopView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func refreshTopView() {
        TripInformService.shared.getTripInfo(groupID: tripData?._id ?? "") { [self] (response) in
            switch(response)
            {
            case .success(let data):
                if let tripResponse = data as? TripInfoResponse {
                    let tripInfo = tripResponse.data
                    tripData?.startDate = tripInfo.startDate
                    tripData?.endDate = tripInfo.endDate
                    tripData?.travelName = tripInfo.travelName
                    tripData?.destination = tripInfo.destination
                    setupTopView()
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
}

extension MemberViewController {
    private func setupFirstData() {
        guard let model = (self.tabBarController as! TripViewController).tripData else { return }
        tripData = model
        setupTopView()
    }
    /// TopView Setup
    private func setupTopView() {
        topView.setTopViewData(tripData: tripData!)
        MemberViewController.thisID = tripData?._id ?? ""
    }
    
    // MARK: - Button Actions
    
    private func setupButtonAction() {
        topView.backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        topView.profileButton.addTarget(self, action: #selector(profileButtonClicked), for: .touchUpInside)
        topView.settingButton.addTarget(self, action: #selector(settingButtonClicked), for: .touchUpInside)
        topView.memberButton.addTarget(self, action: #selector(memberButtonClicked), for: .touchUpInside)
        topView.codeButton.addTarget(self, action: #selector(codeButtonClicked), for: .touchUpInside)
    }
    
    // MARK: - 서버 통신 (특정 날짜 일정 조회 API)
    
    @objc func backButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func profileButtonClicked(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: "MyPageStoryboard", bundle: nil).instantiateViewController(identifier: "MyPageViewController") as? MyPageViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func settingButtonClicked(_ sender: UIButton) {
        let editTripStoryboard = UIStoryboard(name: "AddTripStoryboard", bundle: nil)
        guard let nextVC = editTripStoryboard.instantiateViewController(identifier: "AddTripViewController") as? AddTripViewController else { return }
        
        let f = DateFormatter()
        f.dateFormat = "yyyy. MM. dd. EEEE"
        f.locale = Locale(identifier: "ko_KR")
        nextVC.groupId = tripData?._id ?? ""
        nextVC.hidesBottomBarWhenPushed = true
        nextVC.topLabelData = "여행정보를\n수정하시겠어요?"
        nextVC.buttonData = "여행 정보 수정하기"
        nextVC.initTitle = tripData?.travelName ?? ""
        nextVC.initLocation = tripData?.destination ?? ""
        nextVC.startDateParsing = f.string(from: tripData!.startDate)
        nextVC.endDateParsing = f.string(from: tripData!.endDate)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func memberButtonClicked(_ sender: UIButton) {
        
        WithPopupView.loadFromXib()
            .setTitle("함께하는 사람")
            .setDescription("총 0명")
            .setConfirmButton("참여코드 복사하기")
            .setGroupId(id: MemberViewController.thisID)
            .present { event in
                 if event == .confirm {
                    ToastView.show("참여코드 복사 완료! 원하는 곳에 붙여넣기 하세요.")
                 }
            }
    }
    
    @objc func codeButtonClicked(_ sender: UIButton) {
        ToastView.show("참여코드 복사 완료! 원하는 곳에 붙여넣기 하세요.")
    }
}
