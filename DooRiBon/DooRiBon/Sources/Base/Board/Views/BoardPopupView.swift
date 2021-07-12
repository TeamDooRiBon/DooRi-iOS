//
//  BoardPopupView.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/12.
//

import UIKit

class BoardPopupView: UIView {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var contentsTextView: UITextView!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var confirmButton: UIButton!

    private var eventHandler: ((_ type: EventType) -> Void)?

    enum EventType {
        case confirm
        case cancel
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        placeholderSetting()
    }
    
    func present(_ eventHandler: @escaping ((_ type: EventType) -> Void)) {
        self.eventHandler = eventHandler
        DispatchQueue.main.async {
            self.frame = UIScreen.main.bounds
            AppDelegate.currentKeyWindow?.addSubview(self)
            UIApplication.topViewController()?.view.endEditing(false)
            self.moveIn()
        }
    }

    func setTitle(_ text: String) -> Self {
        titleLabel.text = text
        return self
    }

    func setDescription(_ text: String) -> Self {
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = 18
        style.minimumLineHeight = 18
        let content = NSAttributedString(string: text, attributes: [.paragraphStyle: style])
        descriptionLabel.attributedText = content
        return self
    }
    
    func placeholderSetting() {
        contentsTextView.delegate = self
        contentsTextView.text = "Ex. 인생사진 찍어오기!"
        contentsTextView.textColor = Colors.gray5.color
        let tapDismiss = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.addGestureRecognizer(tapDismiss)
    }
    
    @objc func dismissKeyboard(){
        contentsTextView.resignFirstResponder()
    }

    private func closeView(_ type: EventType) {
        eventHandler?(type)
        moveOut()
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        closeView(.cancel)
    }
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        closeView(.confirm)
    }
    
    private func moveOut() {
        UIView.animate(withDuration: 0.15) {
            self.alpha = 0
            self.containerView.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }

    private func moveIn() {
        self.alpha = 0.0
        self.containerView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        self.containerView.alpha = 0.0

        UIView.animate(withDuration: 0.2) {
            self.alpha = 1.0
        } completion: { _ in
            UIView.animate(withDuration: 0.05) {
                self.containerView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                self.containerView.alpha = 1.0
            } completion: { _ in
                UIView.animate(withDuration: 0.15) {
                    self.containerView.transform = CGAffineTransform.identity
                }
            }
        }
    }
}

extension BoardPopupView: UITextViewDelegate {
    // TextView Place Holder
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == Colors.gray5.color {
            textView.text = nil
            textView.textColor = Colors.black2.color
        }
        textView.resignFirstResponder()
    }
    // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "제가 바로 PlaceHolder입니다."
            textView.textColor = Colors.gray5.color
        }
        textView.becomeFirstResponder()
    }
}
