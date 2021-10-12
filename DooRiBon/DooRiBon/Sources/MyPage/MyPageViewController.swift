//
//  MyPageViewController.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/15.
//

import UIKit
import Kingfisher
import KakaoSDKUser

class MyPageViewController: UIViewController {

    //MARK:- IBOutlet
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userTripCount: UILabel!
    @IBOutlet weak var userStyleTestCount: UILabel!
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var categoryTableView: UITableView!
    
    //MARK:- Variable
    
    let categories = ["프로필 설정", "알림 설정", "문의하기", "자주 묻는 질문", "로그아웃"]
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setShadow()
        setUI()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setData()
    }
    
    //MARK:- IBAction
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Function
    
    func setShadow() {
        leftView.layer.applyShadow(color: .black, alpha: 0.07, x: 0, y: 3, blur: 10)
        rightView.layer.applyShadow(color: .black, alpha: 0.07, x: 0, y: 3, blur: 10)
    }
    
    func setUI() {
        self.userProfileImage.layer.cornerRadius = self.userProfileImage.frame.height/2
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setTableView() {
        categoryTableView.register(MyPageCategoryTableViewCell.nib(), forCellReuseIdentifier: "MyPageCategoryTableViewCell")
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }
    
    func setData() {
        MyPageService.shared.getMyData{ [self] (response) in
            switch(response)
            {
            case .success(let data):
                if let myPageData = data as? MyPageResponse {
                    userNameLabel.text = myPageData.data.name
                    userEmailLabel.text = myPageData.data.email
                    userProfileImage.kf.setImage(with: URL(string: myPageData.data.image))
                    userTripCount.text = String(myPageData.data.tavelCount)
                    userStyleTestCount.text = String(myPageData.data.tendencyCount)
                }
            case .requestErr(let message):
                print("requestERR", message)
            case .pathErr:
                print("pathERR")
            case .serverErr:
                print("serverERR")
            case .networkFail:
                print("networkERR")
            }
        }
    }
}

    //MARK:- Extension

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: "MyPageCategoryTableViewCell", for: indexPath) as! MyPageCategoryTableViewCell
        
        cell.categoryLabel.text = categories[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 4:
            PopupView.loadFromXib()
                .setTitle("로그아웃 하시겠습니까?")
                .setCancelButton()
                .setConfirmButton()
                .present { event in
                    if event == .confirm {
                        KeyChain.delete(key: "token")
                        UserDefaults.standard.set(false, forKey: "hasBeenLaunchedBeforeFlag")
                        UserApi.shared.logout {(error) in
                            if let error = error {
                                print(error)
                            }
                            else {
                                print("logout() success.")
                            }
                        }
                        guard let loginVC = UIStoryboard(name: "LoginStoryboard", bundle: nil).instantiateViewController(identifier: "LoginViewController") as? LoginViewController else {return}
                        UIApplication.shared.keyWindow?.rootViewController = loginVC
                    }
                }
        default:
            return
        }
    }
}
