//
//  PlanViewController.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/06.
//

import UIKit

class PlanViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var calendar: Calendar = {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.timeZone = .current
        return gregorian
    }() 
    
    var tripData: Group?
    let formatter = DateFormatter()

    // MARK: - Dummy Data
    
    private var dummyData: [Int] = [] {
        didSet {
            calendarView.reloadData()
            print("💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚 dummy", dummyData)
        }
    }
    private var planDummyData: [Schedule] = [] {
        didSet {
            contentsTableView.reloadData()
            print("💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚💚 planDummy", planDummyData)
        }
    }
    private var selectedDate: Int?            // 오늘 날짜를 디폴트 값으로 시작
    private var dataStatus: Bool {
        !planDummyData.isEmpty
    }
    
    // MARK: - IBOutlets

    @IBOutlet weak var calendarAreaView: UIView!
    @IBOutlet weak var calendarView: UICollectionView!
    @IBOutlet weak var contentsTableView: UITableView!
    @IBOutlet private var topView: TripTopView!
    @IBOutlet weak var currentYearLabel: UILabel!
    @IBOutlet weak var currentMonthLabel: UILabel!
    
    private var dates: [String] = []
    static var profileData: [Profile] = []
    static var thisID: String = ""
    var schedule: ScheduleData?
    private var currentDate: String = ""

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("========================view did load============================")
        
        configureUI()
        setupButtonAction()
        setupCollectionView()
        setupTableView()
        
        setupFirstData()
//        refreshTopView()
        setupData()

//        getDate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("========================view will appear============================")
        
//        getSchduleData(date: currentDate)
        refreshTopView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("========================view did appear============================")
        
        print("❣️❣️❣️❣️❣️❣️❣️❣️❣️❣️❣️❣️❣️❣️❣️❣️❣️❣️❣️❣️❣️❣️")
    }
    
    // MARK: - Function
    
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
//                    getDate(start: tripInfo.startDate, end: tripInfo.endDate)
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
    
    func editPlan(groupID: String, scheduleID: String) {
        let editPlanStoryboard = UIStoryboard(name: "AddTripPlanStoryboard", bundle: nil)
        guard let nextVC = editPlanStoryboard.instantiateViewController(identifier: "AddTripPlanViewController") as? AddTripPlanViewController else { return }
        nextVC.hidesBottomBarWhenPushed = true
        nextVC.topLabelData = "일정을 편집하세요"
        nextVC.buttonData = "일정 편집하기"
        nextVC.groupID = groupID
        nextVC.scheduleID = scheduleID
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // MARK: - IBActions
}

// MARK: - Helpers

extension PlanViewController {
    
    // MARK: - Configure
    /// UI Setup
    private func configureUI() {
        navigationController?.navigationBar.isHidden = true
        calendarAreaView.layer.applyShadow(color: .black,
                                           alpha: 0.07,
                                           x: 0,
                                           y: 3,
                                           blur: 10,
                                           spread: 0)
    }
    
    // MARK: - Button Actions
    
    private func setupButtonAction() {
        topView.backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        topView.profileButton.addTarget(self, action: #selector(profileButtonClicked), for: .touchUpInside)
        topView.settingButton.addTarget(self, action: #selector(settingButtonClicked), for: .touchUpInside)
        topView.memberButton.addTarget(self, action: #selector(memberButtonClicked), for: .touchUpInside)
        topView.codeButton.addTarget(self, action: #selector(codeButtonClicked), for: .touchUpInside)
    }
    
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
        nextVC.groupId = tripData?._id ?? ""
        nextVC.hidesBottomBarWhenPushed = true
        nextVC.topLabelData = "여행정보를\n수정하시겠어요?"
        nextVC.buttonData = "여행 정보 수정하기"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func memberButtonClicked(_ sender: UIButton) {
       
        WithPopupView.loadFromXib()
            .setTitle("함께하는 사람")
            .setDescription("총 5명")
            .setConfirmButton("참여코드 복사하기")
            .setGroupId(id: PlanViewController.thisID)
            .present { event in
                 if event == .confirm {
                    ToastView.show("참여코드 복사 완료! 원하는 곳에 붙여넣기 하세요.")
                 }
            }

    }
    
    @objc func codeButtonClicked(_ sender: UIButton) {
        ToastView.show("참여코드 복사 완료! 원하는 곳에 붙여넣기 하세요.")
    }
    
    /// TopView Setup
    private func setupFirstData() {
        guard let model = (self.tabBarController as! TripViewController).tripData else { return }
        tripData = model
        // - DooRiBon.Group(_id: "60ee5078b0e7cd69292948f3", startDate: 2021-07-13 15:00:00 +0000, endDate: 2021-07-17 15:00:00 +0000, travelName: "아기와 나 in 파리", image: "https://dooribon.s3.ap-northeast-2.amazonaws.com/6.png", destination: "프랑스 파리", members: ["채정아", "한상진", "송훈기"])
        print("🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥1 - setupFirst Data \(tripData)")
    }
    /// TopView Setup
    private func setupTopView() {
//        getDate()
        topView.setTopViewData(tripData: tripData!)
        PlanViewController.thisID = tripData?._id ?? ""
    }
    
    private func getDate(start: Date, end: Date) {

        print("🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥 2 - setup Date", self.tripData)
        
//        dummyData = []
        
//        guard let startDate = tripData?.startDate else { return }
//        guard let endDate = tripData?.endDate else { return }
        
        let start = Formatter.date.string(from: start)
        let end = Formatter.date.string(from: end)
        
        print(start, end, 123214124)
        
        dates = DateHelper.getDatesBetweenTwo(from: start, to: end)
        
        print("🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥 3 - setup Date", dates)
        
        let convertDates = dates
        
        print("🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥 4 - Date", convertDates)
//
//        currentDate = DateHelper.isTodayInDates(dates: convertDates)
//        print("🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥 4 - current Date", currentDate)
        
        let _ = dates.map {
            dummyData.append(DateHelper.getOnlyDate(date: $0))
        }
        
        print("🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥 5 - - -", dummyData)
    }
    
    private func calculateCurrentDate() {
        let convertDates = dates
        currentDate = DateHelper.isTodayInDates(dates: convertDates)
        print(currentDate)
    }
    
    func dDayCalculate(startDate: Date, endDate: Date) -> Int {
        return calendar.dateComponents([.day], from: startDate, to: endDate).day!
    }
    
    // MARK: - 서버 통신 (특정 날짜 일정 조회 API)
    
    private func getSchduleData(date: String) {
        
        print("💜💜💜💜💜💜💜💜💜💜💜💜💜💜💜💜💜💜💜💜")
        
        guard let groupId = tripData?._id else { return }
        
        TripPlanDataService.shared.getTripPlan(groupId: groupId,
                                               date: date) { [weak self] (response) in
            switch response {
            case .success(let data):
                print("💜💜💜💜💜💜💜💜💜💜💜💜💜💜💜💜💜💜💜💜")
                if let schedule = data as? [Schedule] {
                    self!.planDummyData = schedule
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
    
    private func getScheduleData(groupId: String, scheduleId: String) {
        ScheduleDataService.shared.getSchedule(groupId: groupId,
                                               scheduleId: scheduleId) { response in
            
            switch response {
            case .success(let data):
                if let scheduleData = data as? ScheduleData {
                    self.schedule = scheduleData
                    let start = scheduleData.startTime
                    let end = scheduleData.endTime
                    
                    let sTime = self.strToDate(type: .hh, date: start)
                    let eTime = self.strToDate(type: .hh, date: end)
                    
                    BottomSheetView.loadFromXib()
                        .setBottomSheetType(.plan)
                        .setHost("\(scheduleData.writer.name)님이 작성")
                        .setInfomation("\(scheduleData.createdAt) 마지막 작성")
                        .setDescription(scheduleData.tilte)
                        .setDetail(time: "\(sTime) - \(eTime)",
                                   destination: scheduleData.location,
                                   memo: scheduleData.memo)
                        .present { event in
                            if event == .edit {
                                // 여기부터 하면 됨
                                self.editPlan(groupID: groupId, scheduleID: scheduleId)
                                
                            } else {
                                PopupView.loadFromXib()
                                    .setTitle("정말 삭제하시겠습니까?")
                                    .setDescription("한번 삭제한 항목은 다시 되돌릴 수 없습니다.\n그래도 삭제를 원하신다면 오른쪽 버튼을 눌러주세요")
                                    .setCancelButton()
                                    .setConfirmButton()
                                    .present { event in
                                        if event == .confirm {
                                            self.deleteSchedule(groupId: groupId, scheduleId: scheduleId)
                                        } else {
                                        }
                                    }
                            }
                        }
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
    
    private func deleteSchedule(groupId: String, scheduleId: String) {
        ScheduleDataService.shared.deleteSchedule(groupId: groupId,
                                               scheduleId: scheduleId) { response in
            switch response {
            
            case .success(let data):
                if data is [Schedule] {
                    self.getSchduleData(date: "2021-07-15")
                    self.contentsTableView.reloadData()
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
    
    /// CollectionView Setup
    private func setupCollectionView() {
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.register(UINib(nibName: "DateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: DateCollectionViewCell.cellId)
    }
    
    /// TableView Setup
    private func setupTableView() {
        contentsTableView.delegate = self
        contentsTableView.dataSource = self

        contentsTableView.register(UINib(nibName: "PlanDataTableViewCell", bundle: nil), forCellReuseIdentifier: PlanDataTableViewCell.cellId)
        contentsTableView.register(UINib(nibName: "NoDataTableViewCell", bundle: nil), forCellReuseIdentifier: NoDataTableViewCell.cellId)
        
        contentsTableView.separatorStyle = .none
        contentsTableView.backgroundColor = .clear
        contentsTableView.rowHeight = UITableView.automaticDimension
    }
    
    /// Dummy Setup
    private func setupData() {
        selectedDate = getTodayInfo()
    }
    
    /// Get Today - 오늘 날짜 얻어오는 함수
    private func getTodayInfo() -> Int {
        let nowDate = Date() // 현재의 Date (ex: 2020-08-13 09:14:48 +0000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd" // 2020-08-13 16:30
        let str = dateFormatter.string(from: nowDate) // 현재 시간의 Date를 format에 맞춰 string으로 반환
        return Int(str) ?? -1
    }
    
    enum TimeType {
        case HH
        case hh
    }
    
    private func strToDate(type: TimeType,date: String) -> String {
        let hour = type == .HH ? "HH" : "a h"
        let dateStr = date // Date 형태의 String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm" // 2020-08-13-16:30
                
        let convertDate = dateFormatter.date(from: dateStr) // Date 타입으로 변환
                
        let myDateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "\(hour):mm" // 2020년 08월 13일 오후 04시 30분
        myDateFormatter.locale = Locale(identifier:"ko_KR")
        let convertStr = myDateFormatter.string(from: convertDate!)
        
        return convertStr
    }
    
    private func setCalendar(date: String) {
        currentYearLabel.text = DateHelper.getOnlyYear(date: date)
        currentMonthLabel.text = DateHelper.getOnlyMonth(date: date)
    }
}

// MARK: - Collection View Data Delegate
extension PlanViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedDate = dummyData[indexPath.row]
        setCalendar(date: dates[indexPath.row])
    }
}

// MARK: - Collection View Data Source
extension PlanViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCollectionViewCell.cellId, for: indexPath) as? DateCollectionViewCell else { return UICollectionViewCell() }
        
        /// 데이터 표시
        cell.dayNumberLabel.text = "D\(indexPath.row + 1)"
        cell.dateLabel.text = String(describing: dummyData[indexPath.row])
        
        /// 선택된 날짜일때만 isSelected 변경
        if dates[indexPath.row] == currentDate {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        } else {
            cell.isSelected = false
        }
        
        return cell
    }
}

// MARK: - Collection View Flow Layout
extension PlanViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /// 셀 사이즈 우선 고정값으로 부여
        return CGSize(width: 24, height: 53)
    }

    // 아이템 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    // 라인 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        18
    }

    // 전체 Edge
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 7, left: 21, bottom: 11, right: 21)
    }
}

extension PlanViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getScheduleData(groupId: tripData?._id ?? "", scheduleId: planDummyData[indexPath.row].id)
    }
}

extension PlanViewController: UITableViewDataSource, PlanHeaderViewDelegate {
    // 델리게이트 메서드
    func didSelectedAddTripButton() {
        let addTripSB = UIStoryboard(name: "AddTripPlanStoryboard", bundle: nil)
        let addTripVC = addTripSB.instantiateViewController(identifier: "AddTripPlanViewController") as! AddTripPlanViewController
        addTripVC.hidesBottomBarWhenPushed = true
        addTripVC.groupID = tripData?._id ?? ""
        addTripVC.startDate = currentDate
        navigationController?.pushViewController(addTripVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = PlanDataHeaderView.loadFromXib()
        headerView.delegate = self
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        51
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataStatus { // 데이터 있을 때 셀 개수 처리
            return planDummyData.count
        } else { // 데이터 있을 때 셀 개수 처리
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataStatus { // 데이터 있을 때 셀처리
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PlanDataTableViewCell.cellId, for: indexPath) as? PlanDataTableViewCell else {
                return UITableViewCell()
            }
            if indexPath.row == 0 {
                cell.bottomLineView.isHidden = planDummyData.count == 1
                cell.topLineView.isHidden = true
            } else if indexPath.row == planDummyData.count - 1 {
                cell.bottomLineView.isHidden = true
            }
            
            let time = strToDate(type: .HH, date: planDummyData[indexPath.row].formatTime)
            
            cell.selectionStyle = .none
            cell.timeLabel.text = time
            cell.planTitleLabel.text = planDummyData[indexPath.row].title
            cell.planDescriptionLabel.text = planDummyData[indexPath.row].memo
            
            return cell
        } else { // 데이터 없을 때 셀처리
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoDataTableViewCell.cellId, for: indexPath) as? NoDataTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            return cell
        }
    }
}
