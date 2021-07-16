//
//  MemberOurTableViewCell.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/09.
//

import UIKit

protocol MemberTableCellDelegate: AnyObject {
    func didDetailLookButtonTapppd(for cell: MemberOurTableViewCell)
}

class MemberOurTableViewCell: UITableViewCell {

    @IBOutlet weak var memberOurBackgroundView: UIView!
    @IBOutlet weak var memberType: UILabel!
    @IBOutlet weak var memberStyleOne: UILabel!
    @IBOutlet weak var memberStyleTwo: UILabel!
    @IBOutlet weak var memberStyleThree: UILabel!
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var memberThumbNailImage: UIImageView!
    
    var delegate: MemberTableCellDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellShadowSet()
    }
    
    private func cellShadowSet() {
        contentView.backgroundColor = .clear
        memberOurBackgroundView.layer.applyShadow(color: .black, alpha: 0.07, x: 0, y: 3, blur: 10, spread: 0)
    }

    @IBAction func detailLookButtonTapped(_ sender: Any) {
        delegate?.didDetailLookButtonTapppd(for: self)
    }
}
