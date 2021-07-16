//
//  LastTripTableViewCell.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/04.
//

import UIKit

import Kingfisher

class LastTripTableViewCell: UITableViewCell {

    static let identifier : String = "LastTripTableViewCell"
    
    @IBOutlet weak var tripImageView: UIImageView!
    @IBOutlet weak var tripTitleLabel: UILabel!
    @IBOutlet weak var lastLocationLabel: UILabel!
    @IBOutlet weak var lastMemberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setdata(imageName: String, title: String, location: String, member: String)
    {
        tripImageView.layer.cornerRadius = tripImageView.frame.height / 2
        if let url = URL(string: imageName) {
            tripImageView.kf.setImage(with: url)
        }
        tripTitleLabel.text = title
        lastLocationLabel.text = location
        lastMemberLabel.text = member
    }

}
