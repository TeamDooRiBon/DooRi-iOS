//
//  SceneDelegate.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/06/29.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        // 하나의 윈도우 객체 할당
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        // 맨 처음 보여줄 뷰 컨트롤러 객체 생성 (루트 뷰 컨트롤러로 사용할 객체)
        let rootViewController = UIStoryboard(name: "AddTripPlanStoryboard", bundle: nil)
            .instantiateViewController(identifier: "AddTripPlanViewController")
        
        // 윈도우 위에 쌓이는 것 중에서 윈도우와 가장 근접한 부분을 rootViewController 라고 함
        window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        // 생성한 윈도우를 핵심 윈도우로 보여줌 (윈도우는 여러 개 생성 가능)
        window?.makeKeyAndVisible()

    }

}

