//
//  AnswerCollectionViewCell.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/12.
//

import UIKit

protocol AnswerCollectionViewCellDelegate: NSObject {
    func didSelectedAnswer(_ index: Int)
}

class AnswerCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "AnswerCollectionViewCell"

    @IBOutlet weak var firstAnswerView: AnswerView!
    @IBOutlet weak var secondAnswerView: AnswerView!
    @IBOutlet weak var thirdAnswerView: AnswerView!
    @IBOutlet weak var fourthAnswerView: AnswerView!

    weak var delegate: AnswerCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        firstAnswerView.delegate = self
        secondAnswerView.delegate = self
        thirdAnswerView.delegate = self
        fourthAnswerView.delegate = self
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        firstAnswerView.isSelected = false
        secondAnswerView.isSelected = false
        thirdAnswerView.isSelected = false
        fourthAnswerView.isSelected = false
    }

    func setData(answer1: String,
                 answer2: String,
                 answer3: String,
                 answer4: String)
    {
        firstAnswerView.answerLabel.text = answer1
        secondAnswerView.answerLabel.text = answer2
        thirdAnswerView.answerLabel.text = answer3
        fourthAnswerView.answerLabel.text = answer4
    }
}

extension AnswerCollectionViewCell: AnswerViewDelegate {
    func answerView(_ answerView: AnswerView, didSelected isSelected: Bool) {
        let views: [AnswerView] = [
            firstAnswerView,
            secondAnswerView,
            thirdAnswerView,
            fourthAnswerView
        ]

        for (i, view) in views.enumerated() {
            if view === answerView {
                delegate?.didSelectedAnswer(i)
            } else {
                view.isSelected = false
            }
        }
    }
}
