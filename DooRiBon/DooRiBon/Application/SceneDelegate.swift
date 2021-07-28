//
//  SceneDelegate.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/06/29.
//

import UIKit
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        // 하나의 윈도우 객체 할당
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = SplashViewController()
        // 생성한 윈도우를 핵심 윈도우로 보여줌 (윈도우는 여러 개 생성 가능)
        window?.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let rootViewController = UIStoryboard(name: "LoginStoryboard", bundle: nil)
            .instantiateViewController(identifier: "LoginViewController")
            let mainViewController = UINavigationController(rootViewController: rootViewController)
            self.window?.rootViewController = mainViewController
            self.window?.makeKeyAndVisible()
        }

    }
    
    // 카카오톡 화면 전환을 위한 함수
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }

}


