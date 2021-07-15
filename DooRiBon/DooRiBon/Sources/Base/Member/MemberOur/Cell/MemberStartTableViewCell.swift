//
//  MemberStartTableViewCell.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/11.
//

import UIKit

class MemberStartTableViewCell: UITableViewCell {
    var delegate: goToTestViewProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func goToStyleTestButtonClicked(_ sender: Any) {
        self.delegate?.goToTestView()
    }
}
protocol goToTestViewProtocol {
    func goToTestView()
}
