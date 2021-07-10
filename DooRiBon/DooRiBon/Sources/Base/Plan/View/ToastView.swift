//
//  ToastView.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/08.
//

import UIKit

class ToastView: UIView {
    // MARK: - Properties
    
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var toastMessageLabel: UILabel!
    
    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initSetup()
    }
    
    private func initSetup() {
        containerView.layer.cornerRadius = containerView.frame.height / 2
        toastMessageLabel.textColor = Colors.white9.color
        toastMessageLabel.font = UIFont.SpoqaHanSansNeo(.regular, size: 12)
        containerView.backgroundColor = .black.withAlphaComponent(0.7)
    }
    
    // MARK: - Set Functions
    
    static func show(_ message: String) {
        loadFromXib().show(message: message)
    }
    
    private func show(message: String) {
        toastMessageLabel.text = message
        present()
    }
    
    /// 화면에 띄우는 메서드
    private func present() {
        DispatchQueue.main.async {
            self.frame = UIScreen.main.bounds
            AppDelegate.currentKeyWindow?.addSubview(self)
            UIApplication.topViewController()?.view.endEditing(false)
            self.moveIn()
        }
    }
    
    // MARK: - Animations
    // Hide
    private func moveOut() {
        UIView.animate(withDuration: 0.2, delay: 1.5, animations: {
            self.frame.origin.y = -100
        }, completion: {(isCompleted) in
            self.removeFromSuperview()
        })
    }
    // Show
    private func moveIn() {
        self.containerView.alpha = 0.0
        UIView.animate(withDuration: 0.2) {
            self.containerView.alpha = 1.0
        } completion: { _ in
            self.moveOut()
        }
    }
}

