//
//  BoardSectionHeaderView.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/14.
//

import UIKit

protocol BoardSectionHeaderViewDelegate: AnyObject {
    func didSelectedAddTripButton()
}

class BoardSectionHeaderView: UIView {
    
    @IBOutlet var boardTitle: UILabel!
    
    var delegate: BoardSectionHeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction private func addButtonClicked(_ sender: UIButton) {
        delegate?.didSelectedAddTripButton()
    }
}
