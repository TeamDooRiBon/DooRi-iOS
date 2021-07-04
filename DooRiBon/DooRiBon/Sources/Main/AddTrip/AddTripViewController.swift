//
//  AddTripViewController.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/02.
//

import UIKit

class AddTripViewController: UIViewController {
    
    //MARK:- IBOutlet
    
    /// Label
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var tripLocationLabel: UILabel!
    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var tripPlanLabel: UILabel!
    @IBOutlet weak var tripStartDateLabel: UILabel!
    @IBOutlet weak var tripEndDateLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var photoSelectLabel: UILabel!
    @IBOutlet weak var photoSelectDetailLabel: UILabel!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    /// TextField
    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var tripLocationTextField: UITextField!
    
    /// Button
    @IBOutlet weak var addDateButton: UIButton!
    @IBOutlet weak var startNewTripButton: UIButton!
    
    /// View
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var startDateView: UIView!
    @IBOutlet weak var endDateView: UIView!
    
    //MARK:- Variable
    
    var photoList: [PhotoCollectionViewModel] = []
    var photoIsSelected = false
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        photoListSet()
        notificationSet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //MARK:- Function
    
    func configureUI() {
        
        /// Label
        topLabel.numberOfLines = 2
        topLabel.font = UIFont.SpoqaHanSansNeo(.bold, size: 23)
        topLabel.text = "번들님의 새로운 여행\n같이 시작해요!"
        
        tripNameLabel.text = "여행 이름을 지어주세요"
        tripNameLabel.font = UIFont.SpoqaHanSansNeo(.medium, size: 16)
        
        tripLocationLabel.text = "어디로 여행가세요?"
        tripLocationLabel.font = UIFont.SpoqaHanSansNeo(.medium, size: 16)
        
        tripPlanLabel.text = "여행 일정을 등록해주세요"
        tripPlanLabel.font = UIFont.SpoqaHanSansNeo(.medium, size: 16)
        
        tripStartDateLabel.text = "시작 날짜"
        tripStartDateLabel.font = UIFont.SpoqaHanSansNeo(.regular, size: 12)
        tripStartDateLabel.textColor = Colors.gray5.color
        
        tripEndDateLabel.text = "끝나는 날짜"
        tripEndDateLabel.font = UIFont.SpoqaHanSansNeo(.regular, size: 12)
        tripEndDateLabel.textColor = Colors.gray5.color
        
        startDateLabel.text = ""
        endDateLabel.text = ""
        
        photoSelectLabel.text = "대표 사진을 선택해주세요"
        photoSelectLabel.font = UIFont.SpoqaHanSansNeo(.medium, size: 16)
        
        photoSelectDetailLabel.text = "여행의 대표사진으로 활용될 사진을 두리번이 준비했어요!"
        photoSelectDetailLabel.font = UIFont.SpoqaHanSansNeo(.regular, size: 12)
        photoSelectDetailLabel.textColor = Colors.gray5.color
        
        /// TextField
        tripNameTextField.placeholder = "Ex. 물넘어 제주 속 두리번"
        tripNameTextField.borderWidth = 1
        tripNameTextField.cornerRadius = 5
        tripNameTextField.borderColor = Colors.gray6.color
        
        tripLocationTextField.placeholder = "Ex. 제주도 서귀포시"
        tripLocationTextField.borderWidth = 1
        tripLocationTextField.cornerRadius = 5
        tripLocationTextField.borderColor = Colors.gray6.color
        
        /// Button
        addDateButton.setTitle("   + 날짜 추가하기   ", for: .normal)
        addDateButton.titleLabel?.font = UIFont.SpoqaHanSansNeo(.regular, size: 14)
        addDateButton.setTitleColor(.white, for: .normal)
        addDateButton.backgroundColor = Colors.pointBlue.color
        addDateButton.cornerRadius = 12
        
        startNewTripButton.isEnabled = false
        startNewTripButton.setTitle("새로운 여행 시작하기", for: .normal)
        startNewTripButton.titleLabel?.font = UIFont.SpoqaHanSansNeo(.medium, size: 15)
        startNewTripButton.setTitleColor(Colors.black3.color, for: .normal)
        startNewTripButton.backgroundColor = Colors.gray7.color
        startNewTripButton.cornerRadius = 12
        
        /// View
        mainView.backgroundColor = Colors.white8.color
        
        startDateView.backgroundColor = Colors.gray7.color
        startDateView.borderWidth = 1
        startDateView.cornerRadius = 5
        startDateView.borderColor = Colors.gray6.color
        
        endDateView.backgroundColor = Colors.gray7.color
        endDateView.borderWidth = 1
        endDateView.cornerRadius = 5
        endDateView.borderColor = Colors.gray6.color
        
        /// CollectionView
        photoCollectionView.backgroundColor = Colors.gray7.color
        
    }
    
    /// 추후 서버 연동시 변경될 함수입니다.
    func photoListSet() {
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register((UINib(nibName: "PhotoCollectionViewCell", bundle: nil)), forCellWithReuseIdentifier: "photoCell")
        for _ in 0...15 {
            photoList.append(PhotoCollectionViewModel(photoName: "dummyImg"))
        }
    }
    
    func notificationSet() {
        NotificationCenter.default.addObserver(self, selector: #selector(checking), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    @IBAction func startNewTripButtonClicked(_ sender: Any) {
        print("Test!")
    }
    
    @objc func checking() {
        if tripNameTextField.text != "" && tripLocationTextField.text != "" && photoIsSelected == true {
            startNewTripButton.backgroundColor = Colors.pointOrange.color
            startNewTripButton.isEnabled = true
            startNewTripButton.setTitleColor(.white, for: .normal)
        } else {
            startNewTripButton.backgroundColor = Colors.gray7.color
            startNewTripButton.setTitleColor(Colors.black3.color, for: .normal)
            startNewTripButton.isEnabled = false
        }
    }
}

//MARK:- Extension

extension AddTripViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell()}
        let photo = photoList[indexPath.row]
        cell.setDate(imageName: photo.photoName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        photoIsSelected = true
        checking()
    }
}

extension AddTripViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
}
