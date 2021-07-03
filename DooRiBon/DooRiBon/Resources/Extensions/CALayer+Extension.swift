//
//  CALayer.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/03.
//


/*
 쉐도우 적용 방법
 
 제플린에서 설정된 값을 기준으로, 아래와 같은 예시와 같이 사용!
 ImageView.layer.applyShadow(color: .black,
                                    alpha: 0.25,
                                    x: 0,
                                    y: 4,
                                    blur: 4)
 */

import Foundation
import UIKit

extension CALayer {
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
