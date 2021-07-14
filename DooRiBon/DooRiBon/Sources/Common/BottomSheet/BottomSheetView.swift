//
//  BottomSheetView.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/14.
//

import UIKit

class BottomSheetView: UIView {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageLabel: UIImageView!
    @IBOutlet weak var hostLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var boardDescriptionLabel: UILabel!
    @IBOutlet weak var detailStackView: UIStackView!
    @IBOutlet weak var timeStackView: UIStackView!
    @IBOutlet weak var destinationStackView: UIStackView!
    @IBOutlet weak var memoStackView: UIStackView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var bottomSheetViewTopConstraint: NSLayoutConstraint!
    
    private var eventHandler: ((_ type: EventType) -> Void)?
    
    private var defaultHeight: CGFloat = 300

    enum BottomSheetType {
        case plan
        case board
    }

    enum EventType {
        case edit
        case delete
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        containerView.layer.cornerRadius = 28
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissAlertController() {
        self.moveOut()
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

    func setHost(_ text: String) -> Self {
        hostLabel.text = text
        return self
    }

    func setDescription(_ text: String) -> Self {
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = 26
        style.minimumLineHeight = 26
        let content = NSAttributedString(string: text, attributes: [.paragraphStyle: style])
        boardDescriptionLabel.attributedText = content
        return self
    }
    
    func setDetail(time: String, destination: String, memo: String) -> Self {
        timeLabel.text = time
        destinationLabel.text = destination
        memoLabel.text = memo
        return self
    }

    func setBottomSheetType(_ type: BottomSheetType) -> Self {
        timeStackView.isHidden = type == .board
        destinationStackView.isHidden = type == .board
        memoStackView.isHidden = type == .board
        return self
    }


    @IBAction private func deleteAction(_ sender: UIButton) {
        closeView(.delete)
    }

    @IBAction private func editAction(_ sender: UIButton) {
        closeView(.edit)
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
    
//    private func slideIn() {
//        print("slideIn")
//        let safeAreaHeight: CGFloat = safeAreaLayoutGuide.layoutFrame.height
//        let bottomPadding: CGFloat = safeAreaInsets.bottom
//
////        bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - defaultHeight
//        containerView.snp.updateConstraints {
//            $0.top.equalToSuperview().offset(bottomSheetViewTopConstraint.constant)
//        }
//
//        self.alpha = 0.0
//        self.containerView.alpha = 0.0
//
//        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
//            self.layoutIfNeeded()
//        } ,completion: { _ in
//
//        })
//    }
}
