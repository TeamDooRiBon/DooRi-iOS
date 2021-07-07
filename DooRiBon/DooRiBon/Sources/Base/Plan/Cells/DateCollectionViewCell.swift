//
//  DateCollectionViewCell.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/06.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    
    static let cellId = "DateCollectionViewCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var dayNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var focusView: UIView!
    
    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    // MARK: - Selection
    // 셀 선택 상태에 따라서 UI 변경
    override var isSelected: Bool {
        didSet {
            if isSelected {
                focusView.isHidden = false
                dateLabel.textColor = Colors.white9.color
            } else {
                focusView.isHidden = true
                dateLabel.textColor = Colors.pointBlue.color
            }
        }
    }
    
    // MARK: - Configure
    
    private func configureUI() {
        dayNumberLabel.textColor = Colors.gray6.color
        dayNumberLabel.font = UIFont.SpoqaHanSansNeo(.regular, size: 10)
        dateLabel.textColor = Colors.pointBlue.color
        dateLabel.font = UIFont.SpoqaHanSansNeo(.medium, size: 12)
    }
}
