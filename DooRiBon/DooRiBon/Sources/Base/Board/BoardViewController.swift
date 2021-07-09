//
//  BoardViewController.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/06.
//

import UIKit

class BoardViewController: UIViewController {
    
    @IBOutlet var iconImageView: [UIImageView]!
    @IBOutlet var iconTitleLabel: [UILabel]!
    @IBOutlet weak private var tableView: UITableView!
    
    let topView = TripTopView()
    let iconName = ["Goal", "Aim", "Role", "Check"]

    @IBOutlet weak var topContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
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
        ToastView.loadFromXib().show(message: "참여코드 복사 완료! 원하는 곳에 붙여넣기 하세요.")
    }
    
    @IBAction private func iconClicked(_ sender: UIButton) {
        /// 이미지 선택/비선택 처리
        let _ = iconImageView.enumerated().map {
            let iconCategory = self.iconName[$0.0]
            let iconName = "iconBoard\(iconCategory)"
            $0.element.image = $0.0 == sender.tag ? UIImage(named: "\(iconName)Active") : UIImage(named: "\(iconName)Inactive")
        }
        /// 라벨 선택/비선택 처리
        let _ = iconTitleLabel.enumerated().map {
            $0.element.textColor = $0.0 == sender.tag ? Colors.pointOrange.color : Colors.gray5.color
        }
        /// 각 버튼 클릭했을때 컨텐츠 영역 처리 (ex. 데이터 리로드)
        switch sender.tag {
        case 0:
            print("여행 목표")
        case 1:
            print("꼭 알아줘")
        case 2:
            print("역할 분담")
        case 3:
            print("체크리스트")
        default:
            return
        }
    }
    
    // MARK: - TableView Setup
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "BoardHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: BoardHeaderTableViewCell.cellId)
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
}

// MARK: - TableView Delegate

extension BoardViewController: UITableViewDelegate {
    
}

// MARK: - TableView DataSource

extension BoardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BoardHeaderTableViewCell.cellId, for: indexPath) as? BoardHeaderTableViewCell else { return UITableViewCell() }
        return cell
    }
}
