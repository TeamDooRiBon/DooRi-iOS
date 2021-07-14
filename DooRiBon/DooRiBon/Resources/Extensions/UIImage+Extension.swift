//
//  UIImage+Extension.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/13.
//

import Foundation
import UIKit

extension UIImage {
    public func resized(to target: CGSize) -> UIImage? {
        let ratio = min(
            target.height / size.height, target.width / size.width
        )
        let newSize = CGSize(
            width: size.width * ratio, height: size.height * ratio
        )
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: CGRect(origin: .zero, size: newSize))
        defer { UIGraphicsEndImageContext() }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
