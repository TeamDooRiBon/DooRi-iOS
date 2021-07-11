//
//  BoardNoDataTableViewCell.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/09.
//

import UIKit

class BoardNoDataTableViewCell: UITableViewCell {
    
    static let cellId = "BoardNoDataTableViewCell"

    @IBOutlet weak var illustImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(imageName: String,
                 message: String,
                 description: String) {
        if let image = UIImage(named: imageName) {
            illustImageView.image = image
        }
        messageLabel.text = message
        descriptionLabel.text = description
    }
}
