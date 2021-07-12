//
//  BoardHeaderTableViewCell.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/09.
//

import UIKit

class BoardHeaderTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    static let cellId = "BoardHeaderTableViewCell"
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    // MARK: - Init
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func writeButtonClicked(_ sender: Any) {
        BoardPopupView.loadFromXib()
            .setTitle("여행 목표")
            .setDescription("이번 여행의 목표를 함께 공유하세요!")
            .present { event in
                if event == .confirm {
                    // confirm action
                }
            }
    }
}
