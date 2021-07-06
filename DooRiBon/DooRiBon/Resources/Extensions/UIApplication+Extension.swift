//
//  UIApplication+Extension.swift
//  DooRiBon
//
//  Created by Lee, Hyejin on 2021/07/06.
//

import UIKit

extension UIApplication {
    var rootViewController: UIViewController? {
        guard let windowScene = connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else {
            return nil
        }
        return sceneDelegate.window?.rootViewController
    }

    class func topViewController(
        _ viewController: UIViewController? = UIApplication.shared.rootViewController
    ) -> UIViewController? {

        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }

        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }

        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }

        return viewController
    }
}
