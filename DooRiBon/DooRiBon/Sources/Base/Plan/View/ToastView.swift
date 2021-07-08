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
    }
    
    // MARK: - Set Functions
    /// 화면에 띄우는 메서드
    func present() {
        DispatchQueue.main.async {
            self.frame = UIScreen.main.bounds
            AppDelegate.currentKeyWindow?.addSubview(self)
            UIApplication.topViewController()?.view.endEditing(false)
            self.moveIn()
        }
    }
    /// 메시지 내용 설정하는 메서드
    func setMessage(_ text: String) -> Self {
        toastMessageLabel.text = text
        return self
    }
    /// 메시지 색상 설정하는 메서드
    func setTextColor(_ color: UIColor) -> Self {
        toastMessageLabel.textColor = color
        return self
    }
    /// 백그라운드 색상 설정하는 메서드
    func setBackgroundColor(_ color: UIColor) -> Self {
        containerView.backgroundColor = color
        return self
    }
    /// 폰트 설정하는 메서드
    func setFont(_ weight: UIFont.SpoqaHanSansNeoType, _ size: CGFloat) -> Self {
        toastMessageLabel.font = UIFont.SpoqaHanSansNeo(weight, size: size)
        return self
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

