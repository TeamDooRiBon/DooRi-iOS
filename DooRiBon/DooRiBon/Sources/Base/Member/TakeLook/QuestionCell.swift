//
//  DooRiBon
//  QuestionCell.swift
//
//  Created by 민 on 2021/07/11.
//

import UIKit

class QuestionCell: UITableViewHeaderFooterView  {
    let tapGestureRecognizer = UITapGestureRecognizer()
    var delegate: HeaderViewDelegate?
    var sectionIndex = 0        // section값을 저장할 property
    var isOpened: Bool = false {
        didSet {
            isOpened ? self.cellButton.setImage(UIImage(named: "iconRightUp"), for: .normal) : self.cellButton.setImage(UIImage(named: "iconRightDown"), for: .normal)
            
            layoutIfNeeded()
        }
    }
    
    @IBOutlet weak var blueCircleView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var cellButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isOpened = false
        blueCircleView.layer.cornerRadius = blueCircleView.frame.height / 2
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // 탭의 어느 부분을 클릭해도 TapGestureRecognizer 실행
        contentView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.addTarget(self, action: #selector(cellExpandButtonClicked(_:)))
    }
    
    // 버튼을 클릭
    @IBAction func cellExpandButtonClicked(_ sender: UIButton) {
        delegate?.didTouchSection(self.sectionIndex)
        isOpened.toggle()
    }
  
}

protocol HeaderViewDelegate: AnyObject {
    func didTouchSection(_ sectionIndex: Int)
}

