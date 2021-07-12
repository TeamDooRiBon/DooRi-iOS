//
//  AnswerCollectionViewCell.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/12.
//

import UIKit

class AnswerCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "AnswerCollectionViewCell"
    
    @IBOutlet weak var firstAnswerView: UIView!
    @IBOutlet weak var secondAnswerView: UIView!
    @IBOutlet weak var thirdAnswerView: UIView!
    @IBOutlet weak var fourthAnswerView: UIView!
    
    @IBOutlet weak var firstCircle: UIView!
    @IBOutlet weak var secondCircle: UIView!
    @IBOutlet weak var thirdCircle: UIView!
    @IBOutlet weak var fourthCircle: UIView!
    
    @IBOutlet weak var firstNumberLabel: UILabel!
    @IBOutlet weak var secondNumberLabel: UILabel!
    @IBOutlet weak var thirdNumberLabel: UILabel!
    @IBOutlet weak var fourthNumberLabel: UILabel!
    
    @IBOutlet weak var firstAnswerLabel: UILabel!
    @IBOutlet weak var secondAnswerLabel: UILabel!
    @IBOutlet weak var thirdAnswerLabel: UILabel!
    @IBOutlet weak var fourthAnswerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeCircleView()
    }
    
    @IBAction func answerButtonClicked(_ sender: UIButton) {
        self.isSelected = !self.isSelected
        switch sender.tag {
        case 0:
            if isSelected {
                firstAnswerView.backgroundColor = UIColor(named: "pointBlue")
                firstCircle.backgroundColor = UIColor(named: "white9")
                firstNumberLabel.textColor = UIColor(named: "pointBlue")
                firstAnswerLabel.textColor = UIColor(named: "white9")
            }
            else {
                firstAnswerView.backgroundColor = UIColor(named: "white9")
                firstCircle.backgroundColor = UIColor(named: "subOrange1")
                firstNumberLabel.textColor = UIColor(named: "white9")
                firstAnswerLabel.textColor = UIColor(named: "black3")
            }
        case 1:
            if isSelected {
                secondAnswerView.backgroundColor = UIColor(named: "pointBlue")
                secondCircle.backgroundColor = UIColor(named: "white9")
                secondNumberLabel.textColor = UIColor(named: "pointBlue")
                secondAnswerLabel.textColor = UIColor(named: "white9")
            }
            else {
                secondAnswerView.backgroundColor = UIColor(named: "white9")
                secondCircle.backgroundColor = UIColor(named: "subOrange1")
                secondNumberLabel.textColor = UIColor(named: "white9")
                secondAnswerLabel.textColor = UIColor(named: "black3")
            }
        case 2:
            if isSelected {
                thirdAnswerView.backgroundColor = UIColor(named: "pointBlue")
                thirdCircle.backgroundColor = UIColor(named: "white9")
                thirdNumberLabel.textColor = UIColor(named: "pointBlue")
                thirdAnswerLabel.textColor = UIColor(named: "white9")
            }
            else {
                thirdAnswerView.backgroundColor = UIColor(named: "white9")
                thirdCircle.backgroundColor = UIColor(named: "subOrange1")
                thirdNumberLabel.textColor = UIColor(named: "white9")
                thirdAnswerLabel.textColor = UIColor(named: "black3")
            }
        case 3:
            if isSelected {
                fourthAnswerView.backgroundColor = UIColor(named: "pointBlue")
                fourthCircle.backgroundColor = UIColor(named: "white9")
                fourthNumberLabel.textColor = UIColor(named: "pointBlue")
                fourthAnswerLabel.textColor = UIColor(named: "white9")
            }
            else {
                fourthAnswerView.backgroundColor = UIColor(named: "white9")
                fourthCircle.backgroundColor = UIColor(named: "subOrange1")
                fourthNumberLabel.textColor = UIColor(named: "white9")
                fourthAnswerLabel.textColor = UIColor(named: "black3")
            }
        default:
            return
        }
        
        
    }
    
    func setData(answer1: String,
                 answer2: String,
                 answer3: String,
                 answer4: String)
    {
        firstAnswerLabel.text = answer1
        secondAnswerLabel.text = answer2
        thirdAnswerLabel.text = answer3
        fourthAnswerLabel.text = answer4
    }
    
    func makeCircleView()
    {
        firstCircle.layer.cornerRadius = firstCircle.frame.height / 2
        secondCircle.layer.cornerRadius = secondCircle.frame.height / 2
        thirdCircle.layer.cornerRadius = thirdCircle.frame.height / 2
        fourthCircle.layer.cornerRadius = fourthCircle.frame.height / 2
    }
    
}
