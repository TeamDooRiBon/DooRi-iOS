//
//  BoardViewController.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/06.
//

import UIKit

class BoardViewController: UIViewController {
    
    let topView = TripTopView()

    @IBOutlet weak var topContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
}

extension BoardViewController {
    // MARK: - Setup
    
    private func setupUI() {
        navigationController?.navigationBar.isHidden = true
        
        setupTop()
        setupButtonAction()
    }
    
    // MARK: - Top Area

    private func setupTop() {
        topContainerView.addSubview(topView)
        topView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(190)
        }
    }
    
    // MARK: - Buttons
    
    private func setupButtonAction() {
        topView.backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        topView.profileButton.addTarget(self, action: #selector(profileButtonClicked), for: .touchUpInside)
        topView.settingButton.addTarget(self, action: #selector(settingButtonClicked), for: .touchUpInside)
        topView.memberButton.addTarget(self, action: #selector(memberButtonClicked), for: .touchUpInside)
        topView.codeButton.addTarget(self, action: #selector(codeButtonClicked), for: .touchUpInside)
    }
    
    @objc func backButtonClicked(_ sender: UIButton) {
        print("back button clicked")
    }
    
    @objc func profileButtonClicked(_ sender: UIButton) {
        print("profile button clicked")
    }
    
    @objc func settingButtonClicked(_ sender: UIButton) {
        print("setting button clicked")
    }
    
    @objc func memberButtonClicked(_ sender: UIButton) {
        print("member button clicked")
    }
    
    @objc func codeButtonClicked(_ sender: UIButton) {
        print("code button clicked")
    }
}
