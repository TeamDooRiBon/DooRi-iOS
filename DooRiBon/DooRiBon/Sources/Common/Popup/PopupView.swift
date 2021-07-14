//
//  PopupView.swift
//  DooRiBon
//
//  Created by Lee, Hyejin on 2021/07/06.
//

import UIKit
import SnapKit

/* Example
     PopupView.loadFromXib()
         .setTitle("TITLE")
         .setDescription("Description")
         .setCancelButton()
         .setConfirmButton()
         .present { event in
              if event == .confirm {
                    // confirm action
              }
         }
 */

class PopupView: UIView {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var buttonsStackView: UIStackView!
    @IBOutlet weak var contentsStackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.gray7.color
        button.setTitleColor(Colors.gray4.color, for: .normal)
        button.titleLabel?.font = UIFont.SpoqaHanSansNeo(.medium, size: 15)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
        return button
    }()

    fileprivate lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.pointOrange.color
        button.setTitleColor(Colors.white9.color, for: .normal)
        button.titleLabel?.font = UIFont.SpoqaHanSansNeo(.medium, size: 15)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(confirmAction(_:)), for: .touchUpInside)
        return button
    }()

    private var eventHandler: ((_ type: EventType) -> Void)?

    enum ButtonArrangeType {
        case vertical
        case horizontal
    }

    enum EventType {
        case confirm
        case cancel
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.isHidden = true
        descriptionLabel.isHidden = true
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
        titleLabel.isHidden = false
        titleLabel.text = text
        return self
    }

    func setDescription(_ text: String) -> Self {
        descriptionLabel.isHidden = false
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = 18
        style.minimumLineHeight = 18
        let content = NSAttributedString(string: text, attributes: [.paragraphStyle: style])
        descriptionLabel.attributedText = content
        return self
    }

    func setButtonsArrange(_ type: ButtonArrangeType) -> Self {
        buttonsStackView.axis = type == .horizontal ? .horizontal : .vertical
        return self
    }

    func setConfirmButton(_ text: String = "확인") -> Self {
        confirmButton.setTitle(text, for: .normal)
        buttonsStackView.addArrangedSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        return self
    }

    func setCancelButton(_ text: String? = "취소") -> Self {
        cancelButton.setTitle(text, for: .normal)
        buttonsStackView.addArrangedSubview(cancelButton)
        cancelButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        return self
    }

    @objc private func cancelAction(_ sender: UIButton) {
        closeView(.cancel)
    }

    @objc private func confirmAction(_ sender: UIButton) {
        closeView(.confirm)
    }

    private func closeView(_ type: EventType) {
        eventHandler?(type)
        moveOut()
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
