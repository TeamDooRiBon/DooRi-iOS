//
//  MainViewController.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/06/29.
//

import UIKit

import Kingfisher
import SkeletonView

class MainViewController: UIViewController {
    
    // MARK: - 아울렛
    
    /// 컬렉션, 테이블뷰
    @IBOutlet weak var comeTripCollectionView: UICollectionView!
    @IBOutlet weak var lastTripTableView: UITableView!
    
    /// 라벨
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var comeTripMenuLabel: UILabel!
    @IBOutlet weak var lastTripMenuLabel: UILabel!
    @IBOutlet weak var styleTripMenuLabel: UILabel!
    
    // 버튼
    @IBOutlet weak var startNewTripButton: UIButton!
    
    /// 뷰
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var indicatorBar: UIView!
    @IBOutlet weak var styleTripView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nowTripImageView: UIImageView!
    @IBOutlet weak var nowTripStateView: UIView!
    @IBOutlet weak var nowTripLocationView: UIView!
    @IBOutlet weak var nowTripMemberView: UIView!
    
    @IBOutlet weak var nowTripDateLabel: UILabel!
    @IBOutlet weak var nowTripTitleLabel: UILabel!
    @IBOutlet weak var nowTripLocationLabel: UILabel!
    @IBOutlet weak var nowTripMembersLabel: UILabel!
    @IBOutlet weak var nowTripStateLabel: UILabel!

    /// 제약
    @IBOutlet weak var lastTripViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorBarWidthConstraint: NSLayoutConstraint!
    
    // MARK: - 배열
    var nowTripList: [Group] = []
    var comeTripList : [Group] = []
    var lastTripList : [Group] = []
    
    var allTripData: MainDataModel?
    let formatter = DateFormatter()
    let calendar = Calendar.current

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        shadowSet()
        collectionViewSet()
        tableViewSet()
        registerNoti()
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setTripData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSkeletionUI(.show)
    }
    
    // MARK: - 액션
    
    @IBAction func unwindVC1 (segue : UIStoryboardSegue) {}
    
    @IBAction func nowTripClicked(_ sender: Any) {
        let tripStortboard = UIStoryboard(name: "TripStoryboard", bundle: nil)
        if let tripVC = tripStortboard.instantiateViewController(identifier: "TripViewController") as? TripViewController {
            tripVC.modalPresentationStyle = .overFullScreen
            tripVC.tripData = nowTripList[0]
            present(tripVC, animated: true, completion: nil)
        }
    }
    
    // 새로운 여행 시작하기 : 팝업 StartTrip 뷰컨으로 이동 -> 팝업과 뒷 화면을 연결해야함
    @IBAction func StartTripButtonClicked(_ sender: Any) {
        let nextVC = StartTripViewController(nibName: "StartTripViewController", bundle: nil)
        let naviVC = UINavigationController(rootViewController: nextVC)
        naviVC.modalPresentationStyle = .overCurrentContext
        naviVC.modalTransitionStyle = .crossDissolve
        naviVC.navigationBar.isHidden = true
        self.present(naviVC, animated: true) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
            naviVC.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
        }
    }
    
    @IBAction func goStyleTestButtonClicked(_ sender: Any) {
        let testStortboard = UIStoryboard(name: "StyleQuestionStoryboard", bundle: nil)
        if let testVC = testStortboard.instantiateViewController(identifier: "StyleQuestionViewController") as? StyleQuestionViewController {
            testVC.modalPresentationStyle = .overFullScreen
            testVC.disMissCheck = true
            self.present(testVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func mypageButtonClicked(_ sender: Any) {
        guard let vc = UIStoryboard(name: "MyPageStoryboard", bundle: nil).instantiateViewController(identifier: "MyPageViewController") as? MyPageViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func registerNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveTestNotification(_:)), name: NSNotification.Name("dismissTabBar"), object: nil)
    }
    
    @objc private func didRecieveTestNotification(_ notification: Notification) {
        setTripData()
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.indicatorBar.frame.origin.x = scrollView.contentOffset.x/CGFloat(comeTripList.count)
    }
    
    
    // MARK: - 함수
    // StartTrip 팝업을 dismiss하는 함수
    @objc func dismissAlertController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // 두근두근, 다가오는 여행 부분 데이터
    func setTripData()
    {
        GetMainDataService.shared.getPersonInfo{ [self] (response) in
            switch(response)
            {
            case .success(let comeData):
                if let comeTrip = comeData as? MainDataModel {
                    allTripData = comeTrip
                    comeTripCollectionView.reloadData()
//                    lastTripTableView.reloadData()
                    setDevideTripData()
                    setupSkeletionUI(.hide)
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
    
    func setDevideTripData()
    {
        if (allTripData?.data![0].when == "nowTravels") {
            nowTripList = (allTripData?.data![0].group)!
        }
        if (allTripData?.data![1].when == "comeTravels") {
            comeTripList = (allTripData?.data![1].group)!
            self.indicatorBarWidthConstraint.constant = self.backgroundView.frame.width/CGFloat(self.comeTripList.count)
        }
        if (allTripData?.data![2].when == "endTravels") {
            lastTripList = (allTripData?.data![2].group)!
            let range = lastTripList.count - 3
            if lastTripList.count > 3 {
                for _ in 0...range-1 {
                    lastTripList.popLast()
                }
            }
            if lastTripList.count == 1 {
                lastTripViewHeightConstraint.constant = 200
            } else {
                lastTripViewHeightConstraint.constant = CGFloat(160 * lastTripList.count)
            }
            lastTripTableView.reloadData()
        }
        setNowTripList()
    }
    
    // 번들님은 지금 여행 중이에요! 부분 데이터
    func setNowTripList()
    {
        formatter.dateFormat = "yyyy.MM.dd"
        let start = formatter.string(from: nowTripList[0].startDate)
        let end = formatter.string(from: nowTripList[0].endDate)
        nowTripDateLabel.text = "\(start) - \(end)"
        self.nowTripTitleLabel.text = nowTripList[0].travelName
        self.nowTripLocationLabel.text = nowTripList[0].destination
        if nowTripList[0].members.count == 1 {
            nowTripMembersLabel.text = "\(nowTripList[0].members[0])님과 함께"
        } else {
            nowTripMembersLabel.text = "\(nowTripList[0].members[0])님외 \(nowTripList[0].members.count - 1)명과 함께"
        }
        let url = URL(string: nowTripList[0].image)
        nowTripImageView.layer.cornerRadius = 30
        nowTripImageView.layer.maskedCorners = [
            .layerMinXMinYCorner, .layerMaxXMinYCorner
        ]
        nowTripImageView.kf.setImage(with: url)
    }
    
    // 컬렉션 뷰 부분
    func collectionViewSet()
    {
        comeTripCollectionView.delegate = self
        comeTripCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        comeTripCollectionView.collectionViewLayout = layout
    }
    
    // 테이블 뷰 부분
    func tableViewSet()
    {
        lastTripTableView.delegate = self
        lastTripTableView.dataSource = self
        // automaticDimension
        lastTripTableView.estimatedRowHeight = 150
        lastTripTableView.rowHeight = UITableView.automaticDimension

        let footerView = UIView()
        footerView.frame.size.height = 1
        lastTripTableView.tableFooterView = footerView
    }
    
    // 쉐도우
    func shadowSet()
    {
        styleTripView.layer.applyShadow(color: .black, alpha: 0.1, x: 0, y: 4, blur: 6, spread: 0)
    }
    
    func setUI() {
        self.navigationController?.navigationBar.isHidden = true

        // for skeleton
        self.nowTripStateView.isHidden = true
        self.nowTripLocationLabel.isHidden = true
        self.nowTripMembersLabel.isHidden = true
    }
    
    func dDayCalculate(from date: Date) -> Int {
        return calendar.dateComponents([.day], from: date, to: Date()).day!
    }
}

// MARK: - 익스텐션_컬렉션뷰
extension MainViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comeTripList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let comeTripCell = collectionView.dequeueReusableCell(withReuseIdentifier: ComeTripCollectionViewCell.identifier, for: indexPath) as? ComeTripCollectionViewCell else {return UICollectionViewCell()}
        
        formatter.dateFormat = "yyyy.MM.dd"
        let start = formatter.string(from: comeTripList[indexPath.row].startDate)
        formatter.dateFormat = "MM.dd"
        let end = formatter.string(from: comeTripList[indexPath.row].endDate)
        let dday = dDayCalculate(from: comeTripList[indexPath.row].startDate)
        if (dday == 0) {
            comeTripCell.setData(imageName: comeTripList[indexPath.row].image,
                                 dday: "D-Day!",
                                 title: comeTripList[indexPath.row].travelName,
                                 date: "\(start) - \(end)",
                                 location: comeTripList[indexPath.row].destination,
                                 members: comeTripList[indexPath.row].members[0])
        } else {
            comeTripCell.setData(imageName: comeTripList[indexPath.row].image,
                                 dday: "D\(dday)",
                                 title: comeTripList[indexPath.row].travelName,
                                 date: "\(start) - \(end)",
                                 location: comeTripList[indexPath.row].destination,
                                 members: comeTripList[indexPath.row].members[0])
        }

        comeTripCell.layer.applyShadow(color: .black, alpha: 0.06, x: 3, y: 3, blur: 10, spread: 0)
        comeTripCell.hideAnimation()
        return comeTripCell
    }
    
}

extension MainViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tripStortboard = UIStoryboard(name: "TripStoryboard", bundle: nil)
        if let tripVC = tripStortboard.instantiateViewController(identifier: "TripViewController") as? TripViewController {
            tripVC.modalPresentationStyle = .overFullScreen
            tripVC.tripData = comeTripList[indexPath.row]
            present(tripVC, animated: true, completion: nil)
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize.init(
            width: comeTripCollectionView.bounds.width - 18 * 2,
            height: comeTripCollectionView.bounds.height - 10)   // 정해진 가로/세로를 CGSize형으로 return
    }
    
    // ContentInset 메서드: Cell에서 Content 외부에 존재하는 Inset의 크기를 결정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 18, bottom: 10, right: 18)
    }
    
    // minimumLineSpacing 메서드: Cell 들의 위, 아래 간격 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 18 * 2
    }
    
    // minimumInteritemSpacing 메서드: Cell 들의 좌,우 간격 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - 익스텐션_테이블뷰

extension MainViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tripStortboard = UIStoryboard(name: "TripStoryboard", bundle: nil)
        if let tripVC = tripStortboard.instantiateViewController(identifier: "TripViewController") as? TripViewController {
            tripVC.modalPresentationStyle = .overFullScreen
            tripVC.tripData = lastTripList[indexPath.row]
            present(tripVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lastTripList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tripCell = tableView.dequeueReusableCell(withIdentifier: LastTripTableViewCell.identifier, for: indexPath) as? LastTripTableViewCell else {return UITableViewCell() }
        formatter.dateFormat = "yyyy. MM"
        let date = formatter.string(from: lastTripList[indexPath.row].startDate)
        tripCell.setdata(imageName: lastTripList[indexPath.row].image,
                         title: lastTripList[indexPath.row].travelName,
                         location: lastTripList[indexPath.row].destination,
                         member: lastTripList[indexPath.row].members[0],
                         tripMonth: date)
        tripCell.selectionStyle = .none
        return tripCell
    }
}

// MARK: - UI (UI 관련 작업)

extension MainViewController {
    enum SkeletonState {
        case show
        case hide
    }
    
    // Skeleton UI
    private func setupSkeletionUI(_ type: SkeletonState) {
        SkeletonAppearance.default.tintColor = Colors.backgroundBlue.color
        
        if type == .show {
            // MARK: - 진행중인 여행
            
            self.comeTripCollectionView.showAnimatedSkeleton()
            self.lastTripTableView.showAnimatedSkeleton()
            
            [nowTripImageView, nowTripStateView, nowTripDateLabel,
             nowTripTitleLabel, nowTripLocationView, nowTripMemberView].forEach { $0?.showAnimatedSkeleton() }
            
            // MARK: - 각 카테고리 라벨
            [mainTitleLabel, comeTripMenuLabel, lastTripMenuLabel, styleTripMenuLabel].forEach { $0?.showAnimatedSkeleton() }
            
            // MARK: - 다가오는 여행
            backgroundView.showAnimatedSkeleton()
            styleTripView.showAnimatedSkeleton()

            self.nowTripStateView.isHidden = true
            self.nowTripLocationLabel.isHidden = true
            self.nowTripMembersLabel.isHidden = true
        } else {
            comeTripCollectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
            lastTripTableView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
            
            [nowTripImageView, nowTripStateView, nowTripDateLabel,
             nowTripTitleLabel, nowTripLocationView, nowTripMemberView].forEach {
                $0?.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
             }
            
            [mainTitleLabel, comeTripMenuLabel, lastTripMenuLabel, styleTripMenuLabel].forEach {
                $0?.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
             }

            backgroundView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
            styleTripView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
            
            nowTripLocationLabel.isHidden = false
            nowTripMembersLabel.isHidden = false
            nowTripStateView.isHidden = false

            mainTitleLabel.text = "번들님은\n지금 여행 중이에요!✈️"
            comeTripMenuLabel.text = "두근두근, 다가오는 여행"
            lastTripMenuLabel.text = "추억 속 지난 여행"
            styleTripMenuLabel.text = "번들님은\n어떤 여행을 좋아하세요?"
        }
    }
}

