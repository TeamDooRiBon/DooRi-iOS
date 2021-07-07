import Foundation
import FSCalendar
import UIKit

enum SelectionType : Int {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}

class CalendarCell: FSCalendarCell {
    weak var selectionLayer: CAShapeLayer?
    weak var connectionLayer: CAShapeLayer?

    var selectionType: SelectionType = .none {
        didSet {
            if selectionType == .none {
                self.selectionLayer?.opacity = 0
                self.connectionLayer?.opacity = 0
                self.selectionLayer?.isHidden = true
                self.connectionLayer?.isHidden = true
                return
            }
            setNeedsLayout()
        }
    }

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = Colors.pointBlue.color.cgColor
        selectionLayer.opacity = 0
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel.layer)
        self.selectionLayer = selectionLayer
        self.selectionLayer?.isHidden = true

        let connectionLayer = CAShapeLayer()
        connectionLayer.fillColor = UIColor(red: 107 / 255, green: 143 / 255, blue: 249 / 255, alpha: 0.5).cgColor
        connectionLayer.opacity = 0
        self.contentView.layer.insertSublayer(connectionLayer, below: self.titleLabel.layer)
        self.connectionLayer = connectionLayer
        self.connectionLayer?.isHidden = true

        self.shapeLayer.isHidden = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.selectionLayer?.opacity = 0
        self.connectionLayer?.opacity = 0
        self.contentView.layer.removeAnimation(forKey: "opacity")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionLayer?.frame = self.contentView.bounds//.insetBy(dx: 0, dy: 3)
        self.connectionLayer?.frame = self.contentView.bounds//.insetBy(dx: 0, dy: 3)

        guard var connectionRect = connectionLayer?.bounds else {
            return
        }
        connectionRect.size.height = connectionRect.height * 5 / 6
        if selectionType == .middle {
            self.connectionLayer?.isHidden = false
            self.connectionLayer?.opacity = 1
            self.connectionLayer?.path = UIBezierPath(rect: connectionRect).cgPath
        }
        else if selectionType == .leftBorder {
            self.connectionLayer?.isHidden = false
            self.connectionLayer?.opacity = 1
            var rect = connectionRect
            rect.origin.x = connectionRect.width / 2
            rect.size.width = connectionRect.width / 2
            self.connectionLayer?.path = UIBezierPath(rect: rect).cgPath
        }
        else if selectionType == .rightBorder {
            self.connectionLayer?.isHidden = false
            self.connectionLayer?.opacity = 1
            var rect = connectionRect
            rect.size.width = connectionRect.width / 2
            self.connectionLayer?.path = UIBezierPath(rect: rect).cgPath
        }

        if selectionType == .single || selectionType == .leftBorder || selectionType == .rightBorder {
            self.selectionLayer?.isHidden = false
            self.selectionLayer?.opacity = 1
            let diameter: CGFloat = min(connectionRect.height, connectionRect.width)
            let rect = CGRect(
                x: self.contentView.frame.width / 2 - diameter / 2,
                y: 0,
                width: diameter,
                height: diameter)
            self.selectionLayer?.path = UIBezierPath(ovalIn: rect).cgPath
        }
    }

    override func configureAppearance() {
        super.configureAppearance()
        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
            self.titleLabel.textColor = UIColor.lightGray
        }
    }

}
