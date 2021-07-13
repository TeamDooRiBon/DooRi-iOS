//
//  BoardSectionHeaderView.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/14.
//

import UIKit

class BoardSectionHeaderView: UIView {
    
    @IBOutlet private var boardTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction private func addButtonClicked(_ sender: UIButton) {
        print(11111, "추가하기 버튼 클릭")
        BoardPopupView.loadFromXib()
            .setTitle("여행 목표")
            .setDescription("이번 여행의 목표를 함께 공유하세요!")
            .present { event in
                if event == .confirm {
                    // confirm action
                }
            }
    }
}
