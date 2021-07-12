//
//  MemberCodeCopyTableViewCell.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/11.
//

import UIKit

class MemberCodeCopyTableViewCell: UITableViewCell {

    @IBOutlet weak var informLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        informLabelSet()
    }
    
    func informLabelSet() {
        informLabel.text = "아직 진행된 TEST가 없어요\n일행에게 참여코드를 공유하여 여행 유형을 비교해보세요!"
    }

}
