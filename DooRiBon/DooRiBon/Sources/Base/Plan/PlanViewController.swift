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
    
    // MARK: - Dummy Data
    
    private var dummyData: [Int] = [] {
        didSet {
            calendarView.reloadData()
        }
    }
    private var planDummyData: [PlanDataModel] = [] {
        didSet {
            contentsTableView.reloadData()
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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setupButtonAction()
        setupCollectionView()
        setupTableView()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTopView()
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
        print("profile button clicked")
    }
    
    @objc func settingButtonClicked(_ sender: UIButton) {
        print("setting button clicked")
        let editTripStoryboard = UIStoryboard(name: "AddTripStoryboard", bundle: nil)
        guard let nextVC = editTripStoryboard.instantiateViewController(identifier: "AddTripViewController") as? AddTripViewController else { return }
        nextVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func memberButtonClicked(_ sender: UIButton) {
        print("member button clicked")
    }
    
    @objc func codeButtonClicked(_ sender: UIButton) {
        ToastView.show("참여코드 복사 완료! 원하는 곳에 붙여넣기 하세요.")
    }
    
    /// TopView Setup
    private func setupTopView() {
        guard let model = (self.tabBarController as! TripViewController).tripData else { return }
        topView.setTopViewData(tripData: model)
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
        dummyData.append(contentsOf: [
            6, 7, 8, 9, 10, 11,
            12, 13, 14, 15, 16, 17
        ])
        planDummyData.append(contentsOf: [
            PlanDataModel(planTime: "10:00 AM",
                          planTitle: "김포공항 앞에서 모이기",
                          planDescription: "2304 버스 정류장 찾아보기"),
            PlanDataModel(planTime: "12:00 AM",
                          planTitle: "인천공항으로 출발",
                          planDescription: "여권 꼭 챙기기"),
            PlanDataModel(planTime: "12:00 AM",
                          planTitle: "인천공항으로 출발",
                          planDescription: "여권 꼭 챙기기")
        ])
        selectedDate = getTodayInfo()
    }
    
    /// Get Today - 오늘 날짜 얻어오는 함수
    private func getTodayInfo() -> Int {
        let nowDate = Date() // 현재의 Date (ex: 2020-08-13 09:14:48 +0000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM" // 2020-08-13 16:30
        let str = dateFormatter.string(from: nowDate) // 현재 시간의 Date를 format에 맞춰 string으로 반환
        return Int(str) ?? -1
    }
}

// MARK: - Collection View Data Delegate
extension PlanViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedDate = dummyData[indexPath.row]
    }
}

// MARK: - Collection View Data Source
extension PlanViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCollectionViewCell.cellId,
                                                            for: indexPath) as? DateCollectionViewCell else { return UICollectionViewCell() }
        
        /// 데이터 표시
        cell.dayNumberLabel.text = "D\(indexPath.row + 1)"
        cell.dateLabel.text = String(describing: dummyData[indexPath.row])
        
        /// 선택된 날짜일때만 isSelected 변경
        if dummyData[indexPath.row] == selectedDate {
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
        print("\(indexPath.row)번째 셀클릭")
    }
}

extension PlanViewController: UITableViewDataSource, PlanHeaderViewDelegate {
    // 델리게이트 메서드
    func didSelectedAddTripButton() {
        let addTripSB = UIStoryboard(name: "AddTripPlanStoryboard", bundle: nil)
        let addTripVC = addTripSB.instantiateViewController(identifier: "AddTripPlanViewController") as! AddTripPlanViewController
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
            
            cell.selectionStyle = .none
            cell.timeLabel.text = planDummyData[indexPath.row].planTime
            cell.planTitleLabel.text = planDummyData[indexPath.row].planTitle
            cell.planDescriptionLabel.text = planDummyData[indexPath.row].planDescription
            
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
