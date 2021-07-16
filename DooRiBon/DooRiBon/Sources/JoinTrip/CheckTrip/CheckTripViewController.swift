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
        let str1 = self.checkTripData?.startDate.components(separatedBy: "-")
        let str2 = self.checkTripData?.endDate.components(separatedBy: "-")
        let start = str1![0] + ". " + str1![1] + ". " + str1![2]
        let end = str2![1] + ". " + str2![2]
        self.checkTripDateLabel.text = start + " - " + end
        self.checkTripLocationLabel.text = self.checkTripData?.destination
        self.makeTripPersonLabel.text = "\(self.checkTripData?.host ?? "한상진")님이 만든 여행"
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
        
        UIView.animate(withDuration: 1.5, animations: { [self] in
            naviVC.dismiss(animated: true, completion: nil)
            view.layoutIfNeeded()
        })
        
    }
    
    
   
}
