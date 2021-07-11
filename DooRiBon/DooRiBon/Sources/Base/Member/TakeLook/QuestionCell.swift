//
//  DooRiBon
//  QuestionCell.swift
//
//  Created by 민 on 2021/07/11.
//

import UIKit

class QuestionCell: UITableViewHeaderFooterView  {
    let tapGestureRecognizer = UITapGestureRecognizer()
    var sectionNumber: Int = 0
    var delegate: HeaderViewDelegate?
    var sectionIndex = 0        // section값을 저장할 property
    
    @IBOutlet weak var blueCircleView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var questionTitleLabel: UILabel!
    override func awakeFromNib() {
    

        super.awakeFromNib()
        blueCircleView.layer.cornerRadius = blueCircleView.frame.height / 2

    
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // 탭의 어느 부분을 클릭해도 TapGestureRecognizer 실행
        contentView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.addTarget(self, action: #selector(cellExpandButtonClicked(_:)))
    }
    
    // 버튼을 클릭
    @IBAction func cellExpandButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sectionNumber = sectionIndex
        delegate?.didTouchSection(self.sectionNumber)
    }
    
  
}

protocol HeaderViewDelegate: AnyObject {
    func didTouchSection(_ sectionIndex: Int)
}

