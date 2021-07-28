//
//  ComeTripCollectionViewCell.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/04.
//

import UIKit

import Kingfisher
import SkeletonView

class ComeTripCollectionViewCell: UICollectionViewCell {
    static let identifier : String = "ComeTripCollectionViewCell"
    
    @IBOutlet weak var comeTripImageView: UIImageView!
    @IBOutlet weak var ddayLabel: UILabel!
    @IBOutlet weak var comeTripTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var memberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(imageName: String, dday: String, title: String, date: String, location: String, members: String)
    {
        let url = URL(string: imageName)
        comeTripImageView.kf.setImage(with: url)
        ddayLabel.text = dday
        comeTripTitleLabel.text = title
        dateLabel.text = date
        locationLabel.text = location
        memberLabel.text = members
    }
    
    func hideAnimation() {
        [comeTripImageView, ddayLabel, comeTripTitleLabel, dateLabel, locationLabel, memberLabel]
            .forEach { $0?.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5)) }
    }
}
