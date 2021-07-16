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
    
    private var eventHandler: ((_ type: EventType) -> Void)?
    
    private var defaultHeight: CGFloat = 300
    private var isPresented: Bool = false

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

    override func layoutSubviews() {
        super.layoutSubviews()
        if containerView.frame.origin.y == frame.maxY, !isPresented {
            layoutIfNeeded()
            containerView.snp.updateConstraints {
                $0.top.equalTo(snp.bottom).inset(containerView.frame.height)
            }
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            } completion: { _ in
                self.isPresented = true
            }
        }
    }
    
    private func setupUI() {
        containerView.layer.cornerRadius = 28
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        containerView.snp.makeConstraints {
            $0.top.equalTo(snp.bottom)
        }
        
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
    
    func setInfomation(_ text: String) -> Self {
        infoLabel.text = text
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
        containerView.snp.updateConstraints {
            $0.top.equalTo(snp.bottom)
        }
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }

    private func moveIn() {
        self.alpha = 0.0
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1.0
        }
    }
}
