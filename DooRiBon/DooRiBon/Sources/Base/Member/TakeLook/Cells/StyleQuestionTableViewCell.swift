//
//  StyleQuestionTableViewCell.swift
//  PagerTab
//
//  Created by 민 on 2021/07/07.
//

import UIKit

class StyleQuestionTableViewCell: UITableViewCell {
    
    static let identifier : String = "StyleQuestionTableViewCell"

    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var peopleCountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        blueView.layer.cornerRadius = blueView.frame.height / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setdata(number: String, question: String)
    {
        numberLabel.text = number
        questionLabel.text = question
    }
}

