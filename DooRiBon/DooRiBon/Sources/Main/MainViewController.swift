//
//  MainViewController.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/06/29.
//

import UIKit
import Kingfisher

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
    
    /// 뷰
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var indicatorBar: UIView!
    @IBOutlet weak var styleTripView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nowTripImageView: UIImageView!
    
    @IBOutlet weak var nowTripDateLabel: UILabel!
    @IBOutlet weak var nowTripTitleLabel: UILabel!
    @IBOutlet weak var nowTripLocationLabel: UILabel!
    @IBOutlet weak var nowTripMembersLabel: UILabel!
    
    /// 제약
    @IBOutlet weak var lastTripViewHeightConstraint: NSLayoutConstraint!
    
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
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setTripData()
        collectionViewSet()
        tableViewSet()
    }
    
    // MARK: - 액션
    
    @IBAction func nowTripClicked(_ sender: Any) {
        let tripStortboard = UIStoryboard(name: "TripStoryboard", bundle: nil)
        if let tripVC = tripStortboard.instantiateViewController(identifier: "TripViewController") as? TripViewController {
            navigationController?.pushViewController(tripVC, animated: true)
            tripVC.tripData = nowTripList[0]
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.indicatorBar.frame.origin.x = scrollView.contentOffset.x/3
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
                    lastTripTableView.reloadData()
                    setDevideTripData()
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
        }
        if (allTripData?.data![2].when == "endTravels") {
            lastTripList = (allTripData?.data![2].group)!
            lastTripViewHeightConstraint.constant = CGFloat(175 * lastTripList.count)
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
        lastTripTableView.estimatedRowHeight = 133
        lastTripTableView.rowHeight = UITableView.automaticDimension

    }
    
    // 쉐도우
    func shadowSet()
    {
        comeTripCollectionView.layer.applyShadow(color: .black, alpha: 0.06, x: 3, y: 3, blur: 10, spread: 0)
        styleTripView.layer.applyShadow(color: .black, alpha: 0.1, x: 0, y: 4, blur: 6, spread: 0)
    }
    
    func setUI() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func dDayCalculate(from date: Date) -> Int {
        return calendar.dateComponents([.day], from: date, to: Date()).day! - 1
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
        
        comeTripCell.setData(imageName: comeTripList[indexPath.row].image,
                            dday: "D\(dday)",
                            title: comeTripList[indexPath.row].travelName,
                            date: "\(start) - \(end)",
                            location: comeTripList[indexPath.row].destination,
                            members: comeTripList[indexPath.row].members[0])

        return comeTripCell
    }
    
}

extension MainViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tripStortboard = UIStoryboard(name: "TripStoryboard", bundle: nil)
        if let tripVC = tripStortboard.instantiateViewController(identifier: "TripViewController") as? TripViewController {
            navigationController?.pushViewController(tripVC, animated: true)
            tripVC.tripData = comeTripList[indexPath.row]
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UIScreen.main.bounds.width      // 현재 사용하는 기기의 width를 가져와서 저장
        let cellWidth = width * (340/375)            // 제플린에서의 비율만큼 곱해서 width를 결정
        let cellHeight = cellWidth * (140/340)        // 제플린에서의 비율만큼 곱해서 height를 결정
        
        return CGSize(width: cellWidth, height: cellHeight)     // 정해진 가로/세로를 CGSize형으로 return
    }
    
    // ContentInset 메서드: Cell에서 Content 외부에 존재하는 Inset의 크기를 결정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero    //  Inset을 사용하지 않는다는 뜻
    }
    
    // minimumLineSpacing 메서드: Cell 들의 위, 아래 간격 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // minimumInteritemSpacing 메서드: Cell 들의 좌,우 간격 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 35
    }
}

// MARK: - 익스텐션_테이블뷰

extension MainViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tripStortboard = UIStoryboard(name: "TripStoryboard", bundle: nil)
        if let tripVC = tripStortboard.instantiateViewController(identifier: "TripViewController") as? TripViewController {
            navigationController?.pushViewController(tripVC, animated: true)
            tripVC.tripData = lastTripList[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lastTripList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let tripCell = tableView.dequeueReusableCell(withIdentifier: LastTripTableViewCell.identifier, for: indexPath) as? LastTripTableViewCell else {return UITableViewCell() }
        print("test")
        tripCell.setdata(imageName: lastTripList[indexPath.row].image,
                         title: lastTripList[indexPath.row].travelName,
                         location: lastTripList[indexPath.row].destination,
                         member: lastTripList[indexPath.row].members[0])
        tripCell.selectionStyle = .none
        
        return tripCell
    }
}

