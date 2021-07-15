//
//  MyPageCategoryTableViewCell.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/15.
//

import UIKit

class MyPageCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static func nib() -> UINib{
        return UINib(nibName: "MyPageCategoryTableViewCell", bundle: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
