//
//  UIApplication+Extension.swift
//  DooRiBon
//
//  Created by Lee, Hyejin on 2021/07/06.
//

import UIKit

extension UIApplication {
    // MARK: 윈도우를 찾아서 rootViewController 반환
    var rootViewController: UIViewController? {
        guard let windowScene = connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else {
            return nil
        }
        return sceneDelegate.window?.rootViewController
    }

    // MARK: 받은 viewController에 가장 상위의 presentedViewController를 찾아 반환
    // - 원하는 viewController가 없을 경우 기본적으로 위에서 찾은 rootViewController를 기준으로 가장 상위의 viewController를 찾음
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
