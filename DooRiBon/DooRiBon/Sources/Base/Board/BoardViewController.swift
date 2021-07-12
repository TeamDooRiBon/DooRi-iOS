//
//  BoardViewController.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/06.
//

import UIKit

class BoardViewController: UIViewController {
    
    @IBOutlet weak var topContainerView: TripTopView!
    @IBOutlet var iconImageView: [UIImageView]!
    @IBOutlet var iconTitleLabel: [UILabel]!
    @IBOutlet weak private var tableView: UITableView!
    
    let topView = TripTopView()
    let iconName = ["Goal", "Aim", "Role", "Check"]
    let dummyData = [
        DummyDataModel(titleName: "우리의 여행 목표",
                       imageName: "illustDummy1",
                       message: "여행 목표를 공유하세요!",
                       description: "이번 여행에서 어떤 것을\n얻고 싶은지 작성해보세요"),
        DummyDataModel(titleName: "이것만은 꼭 알아줘!",
                       imageName: "illustDummy2",
                       message: "꼭 알려야 할 것들을 미리 공유하세요!",
                       description: "서로 미리 알면 좋을 습관이나\n생활 패턴 등을 함께 이야기해보세요"),
        DummyDataModel(titleName: "나의 역할은",
                       imageName: "illustDummy3",
                       message: "여행 멤버들의 역할을 정하세요!",
                       description: "예약 담당, 돈 관리, 드라이버 등\n각자의 역할을 정해보세요"),
        DummyDataModel(titleName: "우리의 체크리스트",
                       imageName: "illustDummy4",
                       message: "여행 전에 미리 체크하세요!",
                       description: "이번 여행에서 꼭 확인해야\n하는 것들을 미리 공유해요")
    ]
    private var selectedData: DummyDataModel? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupData()
    }
}

extension BoardViewController {
    // MARK: - Setup
    
    private func setupUI() {
        navigationController?.navigationBar.isHidden = true
        
        setupButtonAction()
    }
    
    private func setupData() {
        selectedData = dummyData[0]
    }

    // MARK: - Buttons
    
    private func setupButtonAction() {
        topContainerView.backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        topContainerView.profileButton.addTarget(self, action: #selector(profileButtonClicked), for: .touchUpInside)
        topContainerView.settingButton.addTarget(self, action: #selector(settingButtonClicked), for: .touchUpInside)
        topContainerView.memberButton.addTarget(self, action: #selector(memberButtonClicked), for: .touchUpInside)
        topContainerView.codeButton.addTarget(self, action: #selector(codeButtonClicked), for: .touchUpInside)
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
        ToastView.show("참여코드 복사 완료! 원하는 곳에 붙여넣기 하세요.")
    }
    
    // 예시
    enum Icon: String {
        case goal = "Goal"
        case check
        case role
        case aim
        
        var activeImage: UIImage? {
            UIImage(named: "\(rawValue)Active")
        }
        
        var inActiveImage: UIImage? {
            UIImage(named: "\(rawValue)Inactive")
        }
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
            selectedData = dummyData[0]
        case 1:
            selectedData = dummyData[1]
        case 2:
            selectedData = dummyData[2]
        case 3:
            selectedData = dummyData[3]
        default:
            return
        }
    }
    
    // MARK: - TableView Setup
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "BoardHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: BoardHeaderTableViewCell.cellId)
        tableView.register(UINib(nibName: "BoardNoDataTableViewCell", bundle: nil), forCellReuseIdentifier: BoardNoDataTableViewCell.cellId)
        tableView.register(UINib(nibName: "BoardTableViewCell", bundle: nil), forCellReuseIdentifier: BoardTableViewCell.cellId)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = .clear
    }
}

// MARK: - TableView Delegate

extension BoardViewController: UITableViewDelegate {
}

// MARK: - TableView DataSource

extension BoardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BoardHeaderTableViewCell.cellId, for: indexPath) as? BoardHeaderTableViewCell else { return UITableViewCell() }
            cell.subTitleLabel.text = selectedData?.titleName
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BoardTableViewCell.cellId, for: indexPath) as? BoardTableViewCell else { return UITableViewCell() }
            
            if indexPath.row % 2 == 0 {
                cell.setData(goalContents: "제주도 한라산 등산하기! 아침에 일찍 일어나서 꼭 갈거야 한라산.... ", userName: "김민영")
            } else {
                cell.setData(goalContents: "여행가기", userName: "댕굴")
            }
            
            
            return cell
        }
        
    }
}
