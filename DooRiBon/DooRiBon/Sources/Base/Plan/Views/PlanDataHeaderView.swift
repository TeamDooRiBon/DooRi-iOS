//
//  PlanDataHeaderView.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/07.
//

import UIKit

protocol PlanHeaderViewDelegate: AnyObject {
    func didSelectedAddTripButton()
}

class PlanDataHeaderView: UIView {
    // MARK: - Properties
    var delegate: PlanHeaderViewDelegate?
    
    @IBOutlet weak var dayNumberLabel: UILabel!
    @IBOutlet weak var detailDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func addTripButtonClicked(_ sender: Any) {
        delegate?.didSelectedAddTripButton()
    }
}
