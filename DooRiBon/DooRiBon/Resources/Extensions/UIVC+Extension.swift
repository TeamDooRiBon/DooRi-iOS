//
//  File.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/17.
//

import Foundation
import UIKit
extension UIViewController {
    func keyboardNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - 키보드 높이 세팅
    @objc func keyboardWillShow(_ sender: Notification) {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        
        if height > 800 && height < 815 {
            self.view.frame.origin.y = -100
        } else if height < 800 {
            self.view.frame.origin.y = -160
        }
    }
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0
    }
}
