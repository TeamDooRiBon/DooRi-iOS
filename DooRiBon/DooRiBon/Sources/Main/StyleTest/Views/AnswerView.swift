//
//  AnswerView.swift
//  DooRiBon
//
//  Created by Lee, Hyejin on 2021/07/13.
//

import UIKit
import SnapKit

protocol AnswerViewDelegate: NSObject {
    func answerView(_ answerView: AnswerView, didSelected isSelected: Bool)
}

class AnswerView: UIView {
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!

    weak var delegate: AnswerViewDelegate?

    @IBInspectable
    var number: Int {
        get {
            Int(numberLabel.text ?? "") ?? 0
        }
        set {
            numberLabel.text = "\(newValue)"
        }
    }
    var isSelected = false {
        didSet {
            updateSelection()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        let view = Bundle.main.loadNibNamed("AnswerView", owner: self, options: nil)?.first as! UIView
        addSubview(view)
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        clipsToBounds = true

        let gesture = UITapGestureRecognizer(target: self, action: #selector(pressedAnswerView(_:)))
        addGestureRecognizer(gesture)
        isUserInteractionEnabled = true
    }

    private func updateSelection() {
        backgroundColor = isSelected ? Colors.pointBlue.color : Colors.white9.color
        circleView.backgroundColor = isSelected ? Colors.white9.color : Colors.subOrange1.color
        numberLabel.textColor = isSelected ? Colors.pointBlue.color : Colors.white9.color
        answerLabel.textColor = isSelected ? Colors.white9.color : Colors.black3.color
    }

    @objc private func pressedAnswerView(_ gesture: UITapGestureRecognizer) {
        isSelected.toggle()
        delegate?.answerView(self, didSelected: isSelected)
    }
}
