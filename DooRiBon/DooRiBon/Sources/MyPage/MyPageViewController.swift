//
//  MyPageViewController.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/15.
//

import UIKit

class MyPageViewController: UIViewController {

    // 상단
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!
    
    // 중간
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    
    // 하단
    @IBOutlet weak var categoryTableView: UITableView!
    
    let categories = ["프로필 설정", "알림 설정", "문의하기", "자주 묻는 질문", "로그아웃"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        categoryTableView.register(MyPageCategoryTableViewCell.nib(), forCellReuseIdentifier: "MyPageCategoryTableViewCell")
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }

    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setShadow()
    {
        leftView.layer.applyShadow(color: .black, alpha: 0.07, x: 0, y: 3, blur: 10)
        rightView.layer.applyShadow(color: .black, alpha: 0.07, x: 0, y: 3, blur: 10)
    }
    
    func makeCircle()
    {
        self.userProfileImage.layer.cornerRadius = self.userProfileImage.frame.height/2
    }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: "MyPageCategoryTableViewCell", for: indexPath) as! MyPageCategoryTableViewCell
        
        cell.categoryLabel.text = categories[indexPath.row]

        return cell
    }
    
    
}
