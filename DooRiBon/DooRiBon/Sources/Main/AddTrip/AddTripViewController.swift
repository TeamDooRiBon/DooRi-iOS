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
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    /// TextField
    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var tripLocationTextField: UITextField!
    
    /// Button
    @IBOutlet weak var startNewTripButton: UIButton!
    
    //MARK:- Variable
    
    var photoList: [PhotoCollectionViewModel] = []
    var photoIsSelected = false
    var selectCheck = false
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        photoListSet()
        notificationSet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //MARK:- Function
    
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
        cell.imageSet(imageName: photo.photoName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !selectCheck {
            photoIsSelected = true
            selectCheck = true
        } else {
            photoIsSelected = false
            selectCheck = false
        }
        checking()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectCheck = false
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
