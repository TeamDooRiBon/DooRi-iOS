//
//  PhotoCollectionViewCell.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/03.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    //MARK:- IBOutlet
    
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var checkImage: UIImageView!
    
    
    //MARK:- override Function
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkImage.isHidden = true
    }
    
    //MARK:- override var
    
    override var isSelected: Bool{
        didSet {
            if isSelected {
                checkImage.isHidden = false
            } else {
                checkImage.isHidden = true
            }
        }
    }
    
    func setDate(imageName: String) {
        if let image = UIImage(named: imageName) {
            mainPhoto.image = image
        }
    }

}
