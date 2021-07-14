//
//  MemberPopupCollectionViewCell.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/14.
//

import UIKit

class MemberPopupCollectionViewCell: UICollectionViewCell {
    static let identifier : String = "MemberPopupCollectionViewCell"
    
    @IBOutlet weak var memberProfileImage: UIImageView!
    @IBOutlet weak var memberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(imageName: String,
                 memberName: String) {
        if let image = UIImage(named: imageName)
        {
            memberProfileImage.image = image
        }
        memberLabel.text = memberName
    }
}
