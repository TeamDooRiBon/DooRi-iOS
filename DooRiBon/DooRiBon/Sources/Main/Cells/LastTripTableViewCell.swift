//
//  LastTripTableViewCell.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/04.
//

import UIKit

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
    
    func setdata(imageName: String, title: String, location: String, member: String)
    {
        tripImageView.image = UIImage(named: imageName)
        tripTitleLabel.text = title
        lastLocationLabel.text = location
        lastMemberLabel.text = member
    }

}
