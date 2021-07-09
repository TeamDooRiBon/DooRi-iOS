//
//  ComeTripCollectionViewCell.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/04.
//

import UIKit

class ComeTripCollectionViewCell: UICollectionViewCell {
    static let identifier : String = "ComeTripCollectionViewCell"
    
    @IBOutlet weak var comeTripImageView: UIImageView!
    @IBOutlet weak var ddayLabel: UILabel!
    @IBOutlet weak var comeTripTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    func setData(imageName: String, dday: String, title: String, date: String)
    {
        if let image = UIImage(named: imageName)
        {
            comeTripImageView.image = image
        }
        ddayLabel.text = dday
        comeTripTitleLabel.text = title
        dateLabel.text = date
    }
    
}
