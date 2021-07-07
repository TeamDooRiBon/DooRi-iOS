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
    
    private var isSelectedArray: [Bool] = []  // 셀 선택 유무 담을 Bool 배열
    private var selectedDate: Int?         // 오늘 날짜를 디폴트 값으로 시작
    
    // MARK: - IBOutlets

    @IBOutlet weak var calendarAreaView: UIView!
    @IBOutlet weak var calendarView: UICollectionView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setupCollectionView()
        setupData()
    }
    
    // MARK: - IBActions
    
    @IBAction private func backButtonClicked(_ sender: UIButton) {
        print("뒤로가기 버튼 클릭")
    }
    
    @IBAction private func profileButtonClicked(_ sender: UIButton) {
        print("프로필 버튼 클릭")
    }
    
    @IBAction private func memberButtonClicked(_ sender: UIButton) {
        print("멤버 버튼 클릭")
    }
    
    @IBAction private func codeCopyButtonClicked(_ sender: UIButton) {
        print("참여코드 복사 완료")
    }
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
    
    /// CollectionView Setup
    private func setupCollectionView() {
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.register(UINib(nibName: "DateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: DateCollectionViewCell.cellId)
    }
    
    /// Dummy Setup
    private func setupData() {
        dummyData.append(contentsOf: [
            6, 7, 8, 9, 10, 11,
            12, 13, 14, 15, 16, 17
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
    
    /// 셀 선택 상태 변경해주는 토글 함수
    private func toggleSelection(index: Int) {
        for i in 0..<isSelectedArray.count {
            if i == index {
                isSelectedArray[i] = true
            } else {
                isSelectedArray[i] = false
            }
        }
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
