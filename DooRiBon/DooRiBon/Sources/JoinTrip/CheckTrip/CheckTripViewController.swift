//
//  CheckTripViewController.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/15.
//

import UIKit
import Kingfisher

class CheckTripViewController: UIViewController {

    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var checkTripImage: UIImageView!
    @IBOutlet weak var checkTripTitleLabel: UILabel!
    @IBOutlet weak var checkTripDateLabel: UILabel!
    @IBOutlet weak var checkTripLocationLabel: UILabel!
    @IBOutlet weak var makeTripPersonLabel: UILabel!
    
    let formatter = DateFormatter()
    var checkTripData: JoinTripData?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTripData()
        setShadowView()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setTripData()
    {
        if let url = URL(string: self.checkTripData!.image)
        {
            self.checkTripImage.kf.setImage(with: url)
            checkTripImage.layer.cornerRadius = 12
            checkTripImage.layer.maskedCorners = [
                .layerMinXMinYCorner, .layerMaxXMinYCorner
            ]
        }
        self.checkTripTitleLabel.text = self.checkTripData?.travelName
        var str1 = self.checkTripData?.startDate.components(separatedBy: "-")
        var str2 = self.checkTripData?.endDate.components(separatedBy: "-")
        let start = str1![0] + ". " + str1![1] + ". " + str1![2]
        let end = str2![1] + ". " + str2![2]
        self.checkTripDateLabel.text = start + " - " + end
        self.checkTripLocationLabel.text = self.checkTripData?.destination
        self.makeTripPersonLabel.text = "\(self.checkTripData?.host ?? "한상진")님이 만든 여행"
        
        
//        formatter.dateFormat = "yyyy.MM.dd"
//        let start = formatter.string(from: self.checkTripData!.startDate)
//        let end = formatter.string(from: nowTripList[0].endDate)
//        nowTripDateLabel.text = "\(start) - \(end)"
//        self.nowTripTitleLabel.text = nowTripList[0].travelName
//        self.nowTripLocationLabel.text = nowTripList[0].destination
//        if nowTripList[0].members.count == 1 {
//            nowTripMembersLabel.text = "\(nowTripList[0].members[0])님과 함께"
//        } else {
//            nowTripMembersLabel.text = "\(nowTripList[0].members[0])님외 \(nowTripList[0].members.count - 1)명과 함께"
//        }
    }
    
    func setShadowView() {
        shadowView.layer.applyShadow(color: .black, alpha: 0.07,
                                     x: 0, y: 3, blur: 10)
    }
    
    @IBAction func reInputCodeButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkCompleteButtonClicked(_ sender: Any) {
        let nextVC = JoinCompleteViewController(nibName: "JoinCompleteViewController", bundle: nil)
        let naviVC = UINavigationController(rootViewController: nextVC)
        naviVC.modalPresentationStyle = .overCurrentContext
        naviVC.modalTransitionStyle = .crossDissolve
        naviVC.navigationBar.isHidden = true
        self.present(naviVC, animated: true)
        
    }
    
    
   
}
