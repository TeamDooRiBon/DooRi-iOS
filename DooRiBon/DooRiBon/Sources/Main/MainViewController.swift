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
    
    // MARK: - IBOutlet
    
    /// CollectionView
    @IBOutlet weak var comeTripCollectionView: UICollectionView!
    
    ///TableView
    @IBOutlet weak var lastTripTableView: UITableView!
    
    /// Label
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var comeTripMenuLabel: UILabel!
    @IBOutlet weak var lastTripMenuLabel: UILabel!
    @IBOutlet weak var styleTripMenuLabel: UILabel!
    
    @IBOutlet weak var nowTripDateLabel: UILabel!
    @IBOutlet weak var nowTripTitleLabel: UILabel!
    @IBOutlet weak var nowTripLocationLabel: UILabel!
    @IBOutlet weak var nowTripMembersLabel: UILabel!
    @IBOutlet weak var nowTripStateLabel: UILabel!
    
    /// View
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var indicatorBar: UIView!
    @IBOutlet weak var styleTripView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var nowTripImageView: UIImageView!
    @IBOutlet weak var nowTripStateView: UIView!
    @IBOutlet weak var nowTripLocationView: UIView!
    @IBOutlet weak var nowTripMemberView: UIView!
    @IBOutlet weak var gradientImageView: UIImageView!

    /// Constraint
    @IBOutlet weak var lastTripTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorBarWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Variable
    
    var nowTripList: [Group] = []
    var comeTripList: [Group] = []
    var lastTripList: [Group] = []
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setMainData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSkeletionUI(.show)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.lastTripTableViewHeightConstraint.constant = self.lastTripTableView.contentSize.height
        self.view.layoutIfNeeded()

        self.indicatorBarWidthConstraint.constant = self.backgroundView.frame.width/CGFloat(max(1, self.comeTripList.count))
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func unwindVC1 (segue : UIStoryboardSegue) {}
    
    @IBAction func nowTripClicked(_ sender: Any) {
        let tripStortboard = UIStoryboard(name: "TripStoryboard", bundle: nil)
        if let tripVC = tripStortboard.instantiateViewController(identifier: "TripViewController") as? TripViewController {
            tripVC.modalPresentationStyle = .overFullScreen
            tripVC.tripData = nowTripList[0]
            present(tripVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func startTripButtonClicked(_ sender: Any) {
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
    
    // MARK: - Function
    
    /// StartTrip 팝업을 dismiss하는 함수
    @objc func dismissAlertController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /// 두근두근, 다가오는 여행 부분 데이터
    func setMainData()
    {
        GetMainDataService.shared.getPersonInfo{ [self] (response) in
            switch(response)
            {
            case .success(let data):
                if let mainData = data as? MainDataModel {
                    allTripData = mainData
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
        if allTripData?.data?[0].when == "nowTravels",
            let list = allTripData?.data?[0].group {
            nowTripList = list
        }
        if allTripData?.data?[1].when == "comeTravels",
            let list = allTripData?.data?[1].group {
            comeTripList = list
            comeTripCollectionView.reloadData()
        }
        if allTripData?.data?[2].when == "endTravels",
            let list = allTripData?.data?[2].group {
            lastTripList = list
            lastTripTableView.reloadData()
        }
        setNowTripList()
    }
    
    /// 번들님은 지금 여행 중이에요! 부분 데이터
    func setNowTripList()
    {
        formatter.dateFormat = "yyyy.MM.dd"
        let start = formatter.string(from: nowTripList[0].startDate)
        let end = formatter.string(from: nowTripList[0].endDate)
        nowTripDateLabel.text = "\(start) - \(end)"
        self.nowTripTitleLabel.text = nowTripList[0].travelName
        self.nowTripLocationLabel.text = nowTripList[0].destination
        self.nowTripMembersLabel.text = nowTripList.first?.members.memberText
        let url = URL(string: nowTripList[0].image)
        nowTripImageView.layer.cornerRadius = 30
        nowTripImageView.layer.maskedCorners = [
            .layerMinXMinYCorner, .layerMaxXMinYCorner
        ]
        nowTripImageView.kf.setImage(with: url) { [weak self] error in
            UIView.animate(withDuration: 0.3) {
                self?.gradientImageView.alpha = 1
            }
        }
    }
    
    /// 컬렉션 뷰 부분
    func collectionViewSet()
    {
        comeTripCollectionView.delegate = self
        comeTripCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        comeTripCollectionView.collectionViewLayout = layout
    }
    
    /// 테이블 뷰 부분
    func tableViewSet()
    {
        lastTripTableView.delegate = self
        lastTripTableView.dataSource = self
        lastTripTableView.estimatedRowHeight = 150
        lastTripTableView.rowHeight = UITableView.automaticDimension

        let footerView = UIView()
        footerView.frame.size.height = 1
        lastTripTableView.tableFooterView = footerView
    }
    
    /// 쉐도우
    func shadowSet()
    {
        styleTripView.layer.applyShadow(color: .black, alpha: 0.1, x: 0, y: 4, blur: 6, spread: 0)
    }
    
    func setUI() {
        self.navigationController?.navigationBar.isHidden = true
        self.mainScrollView.delegate = self

        /// for skeleton
        self.nowTripStateView.isHidden = true
        self.nowTripLocationLabel.isHidden = true
        self.nowTripMembersLabel.isHidden = true
    }
    
    func dDayCalculate(from date: Date) -> Int {
        return calendar.dateComponents([.day], from: date, to: Date()).day ?? 0
    }
    
    private func registerNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveTestNotification(_:)), name: NSNotification.Name("dismissTabBar"), object: nil)
    }
    
    @objc private func didRecieveTestNotification(_ notification: Notification) {
        setMainData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == mainScrollView {
            if scrollView.contentOffset.y < 0 {
                scrollView.backgroundColor = Colors.white8.color
            } else {
                scrollView.backgroundColor = Colors.gray7.color
            }
        }
        if scrollView == comeTripCollectionView {
            if scrollView.contentOffset.x > 0 {
                indicatorBar.frame.origin.x = scrollView.contentOffset.x/scrollView.frame.width * self.indicatorBar.frame.width
            }
            if indicatorBar.frame.origin.x > backgroundView.frame.width - indicatorBar.frame.width {
                indicatorBar.frame.origin.x = backgroundView.frame.width - indicatorBar.frame.width
            }
        }
        
    }

}

// MARK: - Extension

extension MainViewController: UICollectionViewDataSource {
    
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
                                 members: comeTripList[indexPath.row].members.memberText)
        } else {
            comeTripCell.setData(imageName: comeTripList[indexPath.row].image,
                                 dday: "D\(dday)",
                                 title: comeTripList[indexPath.row].travelName,
                                 date: "\(start) - \(end)",
                                 location: comeTripList[indexPath.row].destination,
                                 members: comeTripList[indexPath.row].members.memberText)
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
            height: comeTripCollectionView.bounds.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 18, bottom: 10, right: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 18 * 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

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
        return min(lastTripList.count, 3)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tripCell = tableView.dequeueReusableCell(withIdentifier: LastTripTableViewCell.identifier, for: indexPath) as? LastTripTableViewCell else {return UITableViewCell() }
        formatter.dateFormat = "yyyy. MM"
        let date = formatter.string(from: lastTripList[indexPath.row].startDate)
        tripCell.setdata(imageName: lastTripList[indexPath.row].image,
                         title: lastTripList[indexPath.row].travelName,
                         location: lastTripList[indexPath.row].destination,
                         member: lastTripList[indexPath.row].members.memberText,
                         tripMonth: date)
        tripCell.selectionStyle = .none
        return tripCell
    }
}

extension MainViewController {
    
    enum SkeletonState {
        case show
        case hide
    }
    
    /// Skeleton UI
    private func setupSkeletionUI(_ type: SkeletonState) {
        SkeletonAppearance.default.tintColor = Colors.backgroundBlue.color
        
        if type == .show {
            self.comeTripCollectionView.showAnimatedSkeleton()
            self.lastTripTableView.showAnimatedSkeleton()
            
            [nowTripImageView, nowTripStateView, nowTripDateLabel,
             nowTripTitleLabel, nowTripLocationView, nowTripMemberView].forEach { $0?.showAnimatedSkeleton() }
            
            [mainTitleLabel, comeTripMenuLabel, lastTripMenuLabel, styleTripMenuLabel].forEach { $0?.showAnimatedSkeleton() }
            
            backgroundView.showAnimatedSkeleton()
            styleTripView.showAnimatedSkeleton()

            self.nowTripStateView.isHidden = true
            self.nowTripLocationLabel.isHidden = true
            self.nowTripMembersLabel.isHidden = true
            self.gradientImageView.alpha = 0
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

fileprivate extension Array where Element == String {
    var memberText: String {
        var memberText = first ?? ""
        memberText += count == 1 ? "님과 함께" : "님 외 \(count - 1)명과 함께"
        return memberText
    }
}
