//
//  PhotoCollectionViewCell.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/03.
//

import UIKit
import Kingfisher

class PhotoCollectionViewCell: UICollectionViewCell {

    //MARK:- IBOutlet
    
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var shadeView: UIView!
    var selectCheck = false
    
    //MARK:- override Function
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkImage.isHidden = true
        shadeView.alpha = 0
        setSkeletonUI()
    }
    
    //MARK:- override var
    
    override var isSelected: Bool{
        didSet {
            if isSelected && !selectCheck {
                checkImage.isHidden = false
                shadeView.alpha = 1
                selectCheck = true
            } else if isSelected && selectCheck {
                checkImage.isHidden = true
                shadeView.alpha = 0
                selectCheck = false
            } else {
                checkImage.isHidden = true
                shadeView.alpha = 0
                selectCheck = false
            }
        }
    }
    
    //MARK:- Function
    
    func imageSet(imageUrl: URL) {
        mainPhoto.kf.setImage(with: imageUrl)
    }

    private func setSkeletonUI() {
        isSkeletonable = true
        mainPhoto.isSkeletonable = true
    }
}
