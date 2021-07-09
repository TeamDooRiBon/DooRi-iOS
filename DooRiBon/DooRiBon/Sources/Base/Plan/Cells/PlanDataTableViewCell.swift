//
//  PlanDataTableViewCell.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/07.
//

import UIKit

class PlanDataTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let cellId = "PlanDataTableViewCell"

    // MARK: - IBOutlets
    
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var pointView: UIView!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var planBackgroundView: UIView!
    @IBOutlet weak var planTitleLabel: UILabel!
    @IBOutlet weak var planDescriptionLabel: UILabel!
    
    // MARK: - Initialize
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        topLineView.isHidden = false
        bottomLineView.isHidden = false
    }
    
    private func configureUI() {
        pointView.layer.cornerRadius = pointView.frame.height / 2
        planBackgroundView.layer.cornerRadius =  10
        planBackgroundView.layer.applyShadow(color: .black, alpha: 0.07, x: 0, y: 3, blur: 10, spread: 0)
    }
    
}
