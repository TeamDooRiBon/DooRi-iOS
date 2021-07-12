//
//  BoardTableViewCell.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/10.
//

import UIKit

class BoardTableViewCell: UITableViewCell {
    
    static let cellId = "BoardTableViewCell"

    @IBOutlet weak var boardBackgroundView: UIView!
    @IBOutlet weak var goalContentsLabel: UILabel!
    @IBOutlet private var goalUserLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func configureUI() {
        boardBackgroundView.layer.cornerRadius =  10
        boardBackgroundView.layer.applyShadow(color: .black, alpha: 0.07, x: 0, y: 3, blur: 10, spread: 0)
    }
    
    func setData(
        goalContents: String,
        userName: String
    ) {
        goalContentsLabel.text = goalContents
        goalUserLabel.text = userName
    }
}
