//
//  MakeCodeViewController.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/16.
//

import UIKit

class MakeCodeViewController: UIViewController {
    
    @IBOutlet weak var firstCodeLabel: UILabel!
    @IBOutlet weak var secondCodeLabel: UILabel!
    @IBOutlet weak var thirdCodeLabel: UILabel!
    @IBOutlet weak var fourthCodeLabel: UILabel!
    @IBOutlet weak var fifthCodeLabel: UILabel!
    @IBOutlet weak var sixthCodeLabel: UILabel!
    
    var inviteCode: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setChangeCodeLabel()
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func latterButtonClicked(_ sender: Any) {
    }
    
    @IBAction func copyCodeButtonClicked(_ sender: Any) {
        let nextVC = CopyCompleteViewController(nibName: "CopyCompleteViewController", bundle: nil)
        let naviVC = UINavigationController(rootViewController: nextVC)
        naviVC.modalPresentationStyle = .overCurrentContext
        naviVC.modalTransitionStyle = .crossDissolve
        naviVC.navigationBar.isHidden = true
    
        self.present(naviVC, animated: true)
        UIPasteboard.general.string = inviteCode
        
        UIView.animate(withDuration: 1.5, animations: { [self] in
            naviVC.dismiss(animated: true, completion: nil)
            view.layoutIfNeeded()
        })
    }
    
    // code 담아주는 함수
    func setChangeCodeLabel()
    {
        inviteCode = AddTripViewController.code
        var divCode: [Character] = []
        
        for i in 0..<inviteCode.count {
        divCode.append(inviteCode[inviteCode.index(inviteCode.startIndex, offsetBy: i)])
        }

        firstCodeLabel.text = String(divCode[0])
        secondCodeLabel.text = String(divCode[1])
        thirdCodeLabel.text = String(divCode[2])
        fourthCodeLabel.text = String(divCode[3])
        fifthCodeLabel.text = String(divCode[4])
        sixthCodeLabel.text = String(divCode[5])
    }
    
    
}

// 인덱스로 해당 위치의 문자를 구하는 익스텐션
extension String {
    func getChar(at index: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: index)]
    }
}
