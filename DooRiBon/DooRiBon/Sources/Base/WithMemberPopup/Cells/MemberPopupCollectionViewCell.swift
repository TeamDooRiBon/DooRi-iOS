//
//  MemberPopupCollectionViewCell.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/14.
//

import UIKit
import Kingfisher

class MemberPopupCollectionViewCell: UICollectionViewCell {
    static let identifier : String = "MemberPopupCollectionViewCell"
    
    @IBOutlet weak var memberProfileImage: UIImageView!
    @IBOutlet weak var memberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.memberProfileImage.layer.cornerRadius = self.memberProfileImage.frame.height / 2
        // Initialization code
    }

    func setData(imageName: String,
                 memberName: String) {
        if let url = URL(string: imageName)
        {
            print(url)
            memberProfileImage.kf.setImage(with: url)
        }
        memberLabel.text = memberName
    }
}
