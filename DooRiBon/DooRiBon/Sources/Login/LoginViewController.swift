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
        print("유저 토큰 : \(UserDefaults.standard.string(forKey: "jwtToken"))")
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
        if let access = UserDefaults.standard.string(forKey: "jwtToken") {
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
    
    
    //MARK:- IBAction
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
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
                            case .requestErr(_):
                                print("requestErr")
                            case .pathErr:
                                print("pathErr")
                            case .serverErr:
                                print("serverErr")
                            case .networkFail:
                                print("networkFail")
                            }
                        }
                    }
                }
            }
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

}
