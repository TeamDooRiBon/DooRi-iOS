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
        checkAutoLogin()
    }
    
    //MARK:- Function
    
    func configureUI() {
        bottomContentView.layer.cornerRadius = 30
        bottomContentView.layer.maskedCorners = [
            .layerMinXMinYCorner, .layerMaxXMinYCorner
        ]
        bottomContentView.layer.applyShadow(color: Colors.gray_black2.color, alpha: 0.08, x: 0, y: -4, blur: 10, spread: 0)
    }
    
    func checkAutoLogin() {
        if UserDefaults.standard.string(forKey: "jwtToken") != nil {
            goToMain()
        }
    }
    
    func goToMain() {
        let mainSB = UIStoryboard(name: "MainStoryboard", bundle: nil)
        if let mainVC = mainSB.instantiateViewController(identifier: "MainViewController") as? MainViewController {
            mainVC.modalPresentationStyle = .overFullScreen
            self.present(mainVC, animated: true, completion: nil)
        }
    }
    
    func login() {
        print("Login!!")
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoTalk() success.")
                if let kakaoData = oauthToken {
                    LoginService.shared.kakaoLogin(accessToken: kakaoData.accessToken, refreshToken: kakaoData.refreshToken) { result in
                        switch result {
                        case .success(let loginData):
                            print("success")
                            if let userData = loginData as? LoginResponse {
                                UserDefaults.standard.set(userData.data.token, forKey: "jwtToken")
                            }
                            print("액세스 토큰 : \(kakaoData.accessToken)")
                            print("리프레시 토큰 : \(kakaoData.refreshToken)")
                            self.goToMain()
                        case .requestErr(_):
                            print("requestErr")
                        case .pathErr:
                            print("pathErr")
                            print("여기")
                        case .serverErr:
                            print("serverErr")
                        case .networkFail:
                            print("networkFail")
                        }
                    }
                }
            }
        }
    }
    
    func signUp() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            login()
        } else {
            PopupView.loadFromXib()
                .setTitle("카카오톡이 설치되어있지 않습니다.")
                .setDescription("카카오톡 로그인은 카카오톡이 필요합니다.")
                .setConfirmButton()
                .present { _ in
                    self.dismiss(animated: true, completion: nil)
                }
        }
    }
    
    
    //MARK:- IBAction
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        if (AuthApi.hasToken()) { // 카카오 토큰 존재
            UserApi.shared.accessTokenInfo { (data, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                        //로그인 필요
                        self.signUp()
                    }
                }
                else {
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    self.login()
                }
            }
        }
        else {
            // 카카오 토큰 없음
            signUp()
        }
    }
}
