//
//  MemberOurTableViewCell.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/09.
//

import UIKit

class MemberOurTableViewCell: UITableViewCell {

    @IBOutlet weak var memberType: UILabel!
    @IBOutlet weak var memberStyleOne: UILabel!
    @IBOutlet weak var memberStyleTwo: UILabel!
    @IBOutlet weak var memberStyleThree: UILabel!
    @IBOutlet weak var memberName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
