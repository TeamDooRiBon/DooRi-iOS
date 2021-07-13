//
//  BoardViewController.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/06.
//

import UIKit

struct BoardPopupData {
    var title: String
    var description: String
}

class BoardViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var topContainerView: TripTopView!
    @IBOutlet var iconImageView: [UIImageView]!
    @IBOutlet var iconTitleLabel: [UILabel]!
    @IBOutlet weak private var tableView: UITableView!
    
    // MARK: - Properties
    
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
    let popupData = [
        BoardPopupData(title: "여행 목표", description: "이번 여행의 목표를 함께 공유하세요!"),
        BoardPopupData(title: "꼭 알아줘", description: "이번 여행에 함께하는 사람들에게\n나에 대해 꼭 알리고 싶은 것을 작성해주세요!"),
        BoardPopupData(title: "역할 분담", description: "이번 여행에서 나는 이런 역할을 담당할게!"),
        BoardPopupData(title: "체크리스트", description: "준비는 철저하게! 필요한 것을 미리 체크하세요"),
    ]
    
    private var selectedData: DummyDataModel? {
        didSet {
            tableView.reloadData()
        }
    }
    private var selectedTag: String = "goal"
    private var selectedTagIndex: Int = 0
    private var contents: String = ""
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func postTripBoard(contents: String, tag: String) {
        let input = AddBoardRequest(content: contents)
        AddBoardDataService.shared.postTripBoard(input,
                                                 groupId: "60ed24ad317c7b2480ee1ec6",
                                                 tag: tag) { response in
            switch(response)
            {
            case .success(let data) :
                print(data)
            case .requestErr(let message) :
                print(message)
            case .pathErr :
                print("pathERR")
            case .serverErr:
                print("serverERR")
            case .networkFail:
                print("networkFail")
            }
        }
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

    // MARK: - Button Actions
    
    private func setupButtonAction() {
        topContainerView.backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        topContainerView.profileButton.addTarget(self, action: #selector(profileButtonClicked), for: .touchUpInside)
        topContainerView.settingButton.addTarget(self, action: #selector(settingButtonClicked), for: .touchUpInside)
        topContainerView.memberButton.addTarget(self, action: #selector(memberButtonClicked), for: .touchUpInside)
        topContainerView.codeButton.addTarget(self, action: #selector(codeButtonClicked), for: .touchUpInside)
    }
    
    @objc func backButtonClicked(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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
        case check = "Check"
        case role = "Role"
        case aim = "Aim"
        
        var activeImage: UIImage? {
            UIImage(named: "\(rawValue)Active")
        }
        
        var inActiveImage: UIImage? {
            UIImage(named: "\(rawValue)Inactive")
        }
    }
    
    // 태그
    enum Tag: String {
        case goal = "goal"
        case know
        case role
        case check
        
        var selectedTag: String? {
            return "\(rawValue)"
        }
    }
    
    // MARK: - IBActions
    // 버튼 영역에 있는 각 아이콘에 대한 액션
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
            selectedTag = "\(Tag.goal)"
            self.selectedTagIndex = 0
        case 1:
            selectedData = dummyData[1]
            selectedTag = "\(Tag.know)"
            self.selectedTagIndex = 1
        case 2:
            selectedData = dummyData[2]
            selectedTag = "\(Tag.role)"
            self.selectedTagIndex = 2
        case 3:
            selectedData = dummyData[3]
            selectedTag = "\(Tag.check)"
            self.selectedTagIndex = 3
        default:
            return
        }
        
        tableView.reloadData()
    }
    
    // MARK: - TableView Setup
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "BoardNoDataTableViewCell", bundle: nil), forCellReuseIdentifier: BoardNoDataTableViewCell.cellId)
        tableView.register(UINib(nibName: "BoardTableViewCell", bundle: nil), forCellReuseIdentifier: BoardTableViewCell.cellId)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = .clear
    }
}

// MARK: - TableView Delegate

extension BoardViewController: UITableViewDelegate, BoardSectionHeaderViewDelegate, BoardPopupProtocol {
    func sendContentsData(contents: String) {
        self.contents = contents
    }
    
    func didSelectedAddTripButton() {
        print(11111, "\(selectedTag)")
        let boardPopupView = BoardPopupView.loadFromXib()
        boardPopupView.delegate = self
        boardPopupView
            .setTitle(popupData[selectedTagIndex].title)
            .setDescription(popupData[selectedTagIndex].description)
            .present { event in
                if event == .confirm {
                    self.postTripBoard(contents: self.contents, tag: self.selectedTag)
                }
            }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let boardHeaderView = BoardSectionHeaderView.loadFromXib()
        boardHeaderView.delegate = self
        boardHeaderView.boardTitle.text = selectedData?.titleName
        return boardHeaderView
    }
}

// MARK: - TableView DataSource

extension BoardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BoardTableViewCell.cellId, for: indexPath) as? BoardTableViewCell else { return UITableViewCell() }
        
        if indexPath.row % 2 == 0 {
            cell.setData(goalContents: "제주도 한라산 등산하기! 아침에 일찍 일어나서 꼭 갈거야 한라산.... ", userName: "김민영")
        } else {
            cell.setData(goalContents: "여행가기", userName: "댕굴")
        }

        return cell
    }
}
