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

    func setData(answers: [StyleQuestionAnswerWeight],
                 answerNumber: Int?)
    {
        firstAnswerView.answerLabel.text = answers[0].answer
        secondAnswerView.answerLabel.text = answers[1].answer
        thirdAnswerView.answerLabel.text = answers[2].answer
        fourthAnswerView.answerLabel.text = answers[3].answer

        if answerNumber != -1, let number = answerNumber {
            let views: [AnswerView] = [
                firstAnswerView,
                secondAnswerView,
                thirdAnswerView,
                fourthAnswerView
            ]
            views[number - 1].isSelected = true
        }
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
            if view == answerView {
                delegate?.didSelectedAnswer(i)
            } else {
                view.isSelected = false
            }
        }
    }
}
