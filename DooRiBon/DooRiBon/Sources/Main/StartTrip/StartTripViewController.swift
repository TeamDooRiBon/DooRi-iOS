//
//  StartTripViewController.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/05.
//

import UIKit

class StartTripViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func startButtonClicked(_ sender: Any) {
        guard let navi = presentingViewController as? UINavigationController else {
            return
        }
        dismiss(animated: true) {
            let addDateStoryboard = UIStoryboard(name: "AddTripStoryboard", bundle: nil)
            guard let nextVC = addDateStoryboard.instantiateViewController(identifier: "AddTripViewController") as? AddTripViewController else { return }
            nextVC.modalPresentationStyle = .fullScreen
            navi.pushViewController(nextVC, animated: true)
        }
    }
    
    @IBAction func joinButtonClicked(_ sender: Any) {
        guard let navi = presentingViewController as? UINavigationController else {
            return
        }
        dismiss(animated: true) {
            let addDateStoryboard = UIStoryboard(name: "JoinTripStoryboard", bundle: nil)
            guard let nextVC = addDateStoryboard.instantiateViewController(identifier: "JoinTripViewController") as? JoinTripViewController else { return }
            nextVC.modalPresentationStyle = .fullScreen
            navi.pushViewController(nextVC, animated: true)
        }
    }
}
