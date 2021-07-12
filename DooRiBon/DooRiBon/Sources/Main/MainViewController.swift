//
//  MainViewController.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/06/29.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - 아울렛
    
    // 컬렉션, 테이블뷰
    @IBOutlet weak var comeTripCollectionView: UICollectionView!
    @IBOutlet weak var lastTripTableView: UITableView!
    
    // 라벨
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var nowTripDateLabel: UILabel!
    @IBOutlet weak var nowTripTitleLabel: UILabel!
    @IBOutlet weak var comeTripMenuLabel: UILabel!
    @IBOutlet weak var lastTripMenuLabel: UILabel!
    @IBOutlet weak var styleTripMenuLabel: UILabel!
    
    // 뷰
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var indicatorBar: UIView!
    @IBOutlet weak var styleTripView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - 배열
    var comeTripList : [ComeTripListDataModel] = []
    var lastTripList : [LastTripListDataModel] = []
    
    var currentIndex : Int = 0
    var textCount: Int = 0
    

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setComeTripList()
        setLastTripList()
//        scrollViewDidEndDecelerating(comeTripCollectionView)
        
        collectionViewSet()
        tableViewSet()
        shadowSet()
        
    }
    
    // MARK: - 액션
    
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
    @objc func dismissAlertController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // 두근두근, 다가오는 여행 부분 데이터
    func setComeTripList()
    {
        comeTripList.append(contentsOf: [
        ComeTripListDataModel(comeTripImageName: "rectangle322", dday: "D-4", tripTitle: "티미티미 파리 여행",
                              date: "2020.05.21 - 05.23"),
        ComeTripListDataModel(comeTripImageName: "rectangle322", dday: "D-3", tripTitle: "티미티미 파리 여행",
                              date: "2020.05.21 - 05.23"),
        ComeTripListDataModel(comeTripImageName: "rectangle322", dday: "D-2", tripTitle: "티미티미 파리 여행",
                              date: "2020.05.21 - 05.23")
        ])
    }
    
    // 추억 속 지난 여행 부분 데이터
    func setLastTripList()
    {
        lastTripList.append(contentsOf: [
        LastTripListDataModel(tripImageName: "imgLast3", title: "티미들과 파리 여행!"),
        LastTripListDataModel(tripImageName: "imgLast3", title: "티미들과 파리 여행!"),
        LastTripListDataModel(tripImageName: "imgLast3", title: "티미들과 파리 여행!"),])
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
}

// MARK: - 익스텐션_컬렉션뷰
extension MainViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comeTripList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let comeTripCell = collectionView.dequeueReusableCell(withReuseIdentifier: ComeTripCollectionViewCell.identifier, for: indexPath) as? ComeTripCollectionViewCell else {return UICollectionViewCell()}
        
        comeTripCell.setData(imageName: comeTripList[indexPath.row].comeTripImageName,
                             dday: comeTripList[indexPath.row].dday,
                             title: comeTripList[indexPath.row].tripTitle,
                             date: comeTripList[indexPath.row].date)
        return comeTripCell
    }
    
}

extension MainViewController: UICollectionViewDelegate
{
   
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

extension MainViewController: UITableViewDelegate
{

}

extension MainViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lastTripList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let tripCell = tableView.dequeueReusableCell(withIdentifier: LastTripTableViewCell.identifier, for: indexPath) as? LastTripTableViewCell else {return UITableViewCell() }
        
        tripCell.setdata(imageName: lastTripList[indexPath.row].tripImageName,
                         title: lastTripList[indexPath.row].title)
        
        return tripCell
    }
}

