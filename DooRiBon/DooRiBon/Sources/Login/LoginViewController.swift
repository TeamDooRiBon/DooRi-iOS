//
//  LoginViewController.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/12.
//

import UIKit
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

class LoginViewController: UIViewController {
    
    //MARK:- IBOutlet
    
    @IBOutlet weak var bottomContentView: UIView!

    
    //MARK:- Lift Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK:- Function
    
    func configureUI() {
        bottomContentView.layer.cornerRadius = 30
        bottomContentView.layer.maskedCorners = [
            .layerMinXMinYCorner, .layerMaxXMinYCorner
        ]
        bottomContentView.layer.applyShadow(color: Colors.gray_black2.color, alpha: 0.08, x: 0, y: -4, blur: 10, spread: 0)
    }
    
    
    //MARK:- IBACtion
    
//    @IBAction func getUserInform(_ sender: Any) {
//        UserApi.shared.me() {(user, error) in
//            if let error = error {
//                print(error)
//            }
//            else {
//                print("me() success.")
//                if let user = user {
//                    print(user)
//                }
//            }
//        }
//    }
//
//    @IBAction func tokenInform(_ sender: Any) {
//        UserApi.shared.accessTokenInfo(completion: {(accessTokenInfo, error) in
//            if let error = error {
//                print(error)
//            } else {
//                print("accessTokenInfo() success.")
//                print("토큰 정보 : \(accessTokenInfo)")
//            }
//        })
//    }
//
//    @IBAction func testBtn(_ sender: Any) {
//        if (AuthApi.hasToken()) {
//            UserApi.shared.accessTokenInfo { (_, error) in
//                if let error = error {
//                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true {
//                        print("로그인 필요")
//                    } else {
//                        print("기타 에러")
//                    }
//                } else {
//                    print("토큰 유효성 체크 성공(필요 시 토큰 갱신됨)")
//                }
//            }
//        } else {
//            print("로그인 필요")
//        }
//    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoTalk() success.")
                    if let data = oauthToken {
                        print(data)
                    }
                }
            }
        } else {
            PopupView.loadFromXib()
                .setTitle("카카오톡이 설치되어있지 않습니다.")
                .setDescription("카카오 로그인은 카카오톡이 필요합니다.")
                .setConfirmButton()
                .present { _ in
                    self.dismiss(animated: true, completion: nil)
                }
        }
    }

}
