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

// 태그
enum Tag: Int {
    case goal
    case know
    case role
    case check

    var description: String {
        switch self {
        case .goal: return "goal"
        case .know: return "know"
        case .role: return "role"
        case .check: return "check"
        }
    }
}

class BoardViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var topView: TripTopView!
    @IBOutlet var iconImageView: [UIImageView]!
    @IBOutlet var iconTitleLabel: [UILabel]!
    @IBOutlet weak var boardTableView: UITableView!
    
    // MARK: - Properties
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
            boardTableView.reloadData()
        }
    }
    
    private var currentBoardData: [BoardData]? {
        didSet {
            boardTableView.reloadData()
        }
    }
    
    private var selectedTag: String = "goal"
    private var selectedTagIndex: Int = 0
    private var contents: String = ""
    var tripData: Group?
    
    static var profileData: [Profile] = []
    private var thisID: String = ""
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupData()
        setupFirstData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshTopView()
        guard let tag = Tag(rawValue: selectedTagIndex)?.description else { return }
        getBoardData(groupId: self.thisID, tag: tag)
    }
    
    // MARK:- Function
    
    func refreshTopView() {
        TripInformService.shared.getTripInfo(groupID: tripData?._id ?? "") { [self] (response) in
            switch(response)
            {
            case .success(let data):
                if let tripResponse = data as? TripInfoResponse {
                    let tripInfo = tripResponse.data
                    tripData?.startDate = tripInfo.startDate
                    tripData?.endDate = tripInfo.endDate
                    tripData?.travelName = tripInfo.travelName
                    tripData?.destination = tripInfo.destination
                    setupTopView()
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

    private func postTripBoard(contents: String, groupId: String, tag: String) {
        let input = AddBoardRequest(content: contents)
        AddBoardDataService.shared.postTripBoard(input,
                                                 groupId: groupId,
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
    
    private func getBoardData(groupId: String, tag: String) {
        AddBoardDataService.shared.getTripBoard(groupId: groupId,
                                                tag: tag) { response in
            switch(response)
            {
            case .success(let data) :
                if let data = data as? [BoardData] {
                    self.currentBoardData = data
                }

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
    /// TopView Setup
    private func setupFirstData() {
        guard let model = (self.tabBarController as! TripViewController).tripData else { return }
        tripData = model
        setupTopView()
    }
    /// TopView Setup
    private func setupTopView() {
        topView.setTopViewData(tripData: tripData!)
        self.thisID = tripData?._id ?? ""
    }
    
    private func setupUI() {
        navigationController?.navigationBar.isHidden = true
        
        setupButtonAction()
    }
    
    private func setupData() {
        selectedData = dummyData[0]
    }
    
    private func deleteBoardData(groupId: String, tag: String, boardId: String) {
        AddBoardDataService.shared.deleteTripBoard (groupId: groupId,
                                                    tag: tag,
                                                    boardId: boardId) { response in
            switch(response)
            {
            case .success(let data) :
                if let data = data as? [BoardData] {
                    self.currentBoardData = data
                }

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
    
    private func patchBoardData(contents: String, groupId: String, tag: String, boardId: String) {
        let input = AddBoardRequest(content: contents)
        AddBoardDataService.shared.patchTripBoard (input,
                                                   groupId: groupId,
                                                   tag: tag,
                                                   boardId: boardId) { response in

            switch(response)
            {
            case .success(let data) :
                if let data = data as? [BoardData] {
                    self.currentBoardData = data
                }

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
    

    // MARK: - Button Actions
    
    private func setupButtonAction() {
        topView.backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        topView.profileButton.addTarget(self, action: #selector(profileButtonClicked), for: .touchUpInside)
        topView.settingButton.addTarget(self, action: #selector(settingButtonClicked), for: .touchUpInside)
        topView.memberButton.addTarget(self, action: #selector(memberButtonClicked), for: .touchUpInside)
        topView.codeButton.addTarget(self, action: #selector(codeButtonClicked), for: .touchUpInside)
    }
    
    @objc func backButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func profileButtonClicked(_ sender: UIButton) {
        print("profile button clicked")
    }
    
    @objc func settingButtonClicked(_ sender: UIButton) {
        print("setting button clicked")
        let editTripStoryboard = UIStoryboard(name: "AddTripStoryboard", bundle: nil)
        guard let nextVC = editTripStoryboard.instantiateViewController(identifier: "AddTripViewController") as? AddTripViewController else { return }
        nextVC.groupId = tripData?._id ?? ""
        nextVC.hidesBottomBarWhenPushed = true
        nextVC.topLabelData = "여행정보를\n수정하시겠어요?"
        nextVC.buttonData = "여행 정보 수정하기"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func memberButtonClicked(_ sender: UIButton) {
       
        WithPopupView.loadFromXib()
            .setTitle("함께하는 사람")
            .setDescription("총 5명")
            .setConfirmButton("참여코드 복사하기")
            .setGroupId(id: self.thisID)
            .present { event in
                 if event == .confirm {
                    ToastView.show("참여코드 복사 완료! 원하는 곳에 붙여넣기 하세요.")
                 }
            }

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
        
        selectedData = dummyData[sender.tag]
        selectedTagIndex = sender.tag
        
        guard let tag = Tag(rawValue: selectedTagIndex)?.description else { return }
        getBoardData(groupId: self.thisID, tag: tag)
        
        boardTableView.reloadData()
    }
    
    // MARK: - TableView Setup
    
    private func setupTableView() {
        boardTableView.delegate = self
        boardTableView.dataSource = self
        
        boardTableView.register(UINib(nibName: "BoardNoDataTableViewCell", bundle: nil), forCellReuseIdentifier: BoardNoDataTableViewCell.cellId)
        boardTableView.register(UINib(nibName: "BoardTableViewCell", bundle: nil), forCellReuseIdentifier: BoardTableViewCell.cellId)
        
        boardTableView.rowHeight = UITableView.automaticDimension
        boardTableView.estimatedRowHeight = 100
        boardTableView.backgroundColor = .clear
    }
}

// MARK: - TableView Delegate

extension BoardViewController: UITableViewDelegate, BoardSectionHeaderViewDelegate, BoardPopupProtocol {
    func sendContentsData(contents: String) {
        self.contents = contents
        boardTableView.reloadData()
    }
    
    func didSelectedAddTripButton() {
        print(self.selectedTagIndex)
        let selectedTag = Tag(rawValue: selectedTagIndex)
        guard let description = selectedTag?.description else { return }
        
        let boardPopupView = BoardPopupView.loadFromXib()
        boardPopupView.delegate = self
        boardPopupView
            .setTitle(popupData[selectedTagIndex].title)
            .setDescription(popupData[selectedTagIndex].description)
            .present { event in
                if event == .confirm {
                    self.postTripBoard(contents: self.contents, groupId: self.thisID, tag: description)
                    self.getBoardData(groupId: self.thisID, tag: description)
                    self.boardTableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let boardData = currentBoardData![indexPath.row]
        BottomSheetView.loadFromXib()
            .setBottomSheetType(.board)
            .setHost(boardData.name)
            .setInfomation(popupData[selectedTagIndex].title)
            .setDescription(boardData.content)
            .present { event in
                if event == .edit {
                    let boardPopupView = BoardPopupView.loadFromXib()
                    boardPopupView.delegate = self
                    boardPopupView
                        .setTitle(self.popupData[self.selectedTagIndex].title)
                        .setDescription(self.popupData[self.selectedTagIndex].description)
                        .setTextView(boardData.content)
                        .present { event in
                            if event == .confirm {
                                self.patchBoardData(contents: self.contents, groupId: self.thisID, tag: self.selectedTag, boardId: boardData.id)
                            }
                        }
                } else {
                    PopupView.loadFromXib()
                        .setTitle("정말 삭제하시겠습니까?")
                        .setDescription("한번 삭제한 항목은 다시 되돌릴 수 없습니다.\n그래도 삭제를 원하신다면 오른쪽 버튼을 눌러주세요")
                        .setCancelButton()
                        .setConfirmButton()
                        .present { event in
                            if event == .confirm {
                                self.deleteBoardData(groupId: self.thisID, tag: self.selectedTag, boardId: boardData.id)
                            } else {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                }
            }
    }
}

// MARK: - TableView DataSource

extension BoardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentBoardData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BoardTableViewCell.cellId, for: indexPath) as? BoardTableViewCell else { return UITableViewCell() }
        
        if let data = currentBoardData?[indexPath.row] {
            cell.setData(goalContents: data.content, userName: data.name)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}
