//
//  JoinTripViewController.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/04.
//

import UIKit

import SnapKit

class JoinTripViewController: UIViewController {
    // MARK: - Properties
    
    private var currentIndex: Int = 0 {
        didSet {
            if currentIndex == -1 {
                activateCodeInputArea(index: 0)
            }
            codeTextField.forEach {
                if $0.tag == currentIndex {
                    activateCodeInputArea(index: $0.tag)
                } else {
                    deactivateCodeInputArea(index: $0.tag)
                }
            }
        }
    }
    
    var joinData: [JoinTripData]?
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var codeStackView: UIStackView!
    @IBOutlet var codeTextField: [CodeTextField]!
    @IBOutlet weak var joinButton: UIButton!
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTextField()
        registerNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 처음 시작시 첫째칸 활성화
        activateCodeInputArea(index: currentIndex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // 옵저버 해제
        unregisterNotifications()
    }
    
    // MARK: - IBActions
    
    @IBAction func joinTripButtonClicked(_ sender: Any) {
        let inviteCode = checkInviteCode()
        getTripData(inviteCode: inviteCode)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Set up

extension JoinTripViewController {
    
    // MARK: - Configure
    
    /// UI 셋업
    private func configureUI() {
        /// 네비게이션 바 숨김
        navigationController?.navigationBar.isHidden = true
        
        /// 코드칸 쉐도우 셋업
        for codeUIView in codeStackView.arrangedSubviews {
            codeUIView.layer.applyShadow(color: .black,
                                         alpha: 0.07,
                                         x: 0,
                                         y: 3,
                                         blur: 10,
                                         spread: 0)
        }
    }
    
    /// 텍스트필드 셋업
    private func configureTextField() {
        for (index, textField) in codeTextField.enumerated() {
            textField.tintColor = .clear
            textField.delegate = self
            textField.tag = index
            
            /// 코드칸 BackButton 버튼누를때마다 액션 - 클로저로 처리
            /// - 빈칸에서 BackButton 클릭시 : 이전칸 내용 삭제 및 이전칸 포커스
            /// - 마지막칸 채워져있는 상태에서 클릭시 : 내용만 삭제 및 포커스 유지
            textField.backspaceCalled = {
                if index != 0  && textField.text == "" {
                    self.currentIndex = index - 1
                    self.codeTextField[self.currentIndex].text = ""
                }
            }
        }
    }
    
    // MARK: - Private Functions
    
    /// 코드칸 활성화 함수
    /// - 1. 파란색으로 포커스
    /// - 2. 키보드 지정
    private func activateCodeInputArea(index: Int) {
        codeStackView.arrangedSubviews[index].backgroundColor = Colors.backgroundBlue.color
        codeStackView.arrangedSubviews[index].borderWidth = 1
        codeStackView.arrangedSubviews[index].borderColor = Colors.subBlue1.color
        
        codeTextField[index].becomeFirstResponder()
    }
    
    /// 코드칸 비활성화 함수
    /// - 1. 색상 클리어
    /// - 2. 키보드 지정
    private func deactivateCodeInputArea(index: Int) {
        codeStackView.arrangedSubviews[index].backgroundColor = Colors.white9.color
        codeStackView.arrangedSubviews[index].borderColor = .clear

        codeTextField[index].resignFirstResponder()
    }
    
    /// 전체칸 활성화 함수
    /// - 칸 전부 채워졌을때 설정
    private func activateTotalArea() {
        codeStackView.arrangedSubviews.forEach {
            $0.backgroundColor = Colors.white9.color
            $0.layer.borderWidth = 1
            $0.layer.borderColor = Colors.subBlue1.color.cgColor
        }
    }
    
    /// 전체칸 비활성화 함수
    /// - 전부채워진상태에서 지웠을 때 실행
    private func deactivateTotalArea() {
        codeStackView.arrangedSubviews.forEach {
            $0.layer.borderColor = UIColor.clear.cgColor
        }
        activateCodeInputArea(index: currentIndex)
    }
    
    /// 노티피케이션 등록
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(checkTextField), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    /// 노티피케이션 해제
    private func unregisterNotifications() {
        // self에 등록된 옵저버 전체 해제
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 버튼 활성화/비활성화 체크해주기위해 텍스트필드 노티피케이션 등록
    @objc
    func checkTextField() {
        if !codeTextField[currentIndex].text!.isEmpty && currentIndex < 5 {
            currentIndex += 1
        }
        
        var originArray: [UITextField] = []
        codeTextField.forEach {
            originArray.append($0)
        }
        let filteredArray = originArray.filter { $0.text == "" }
        if !filteredArray.isEmpty {
            joinButton.backgroundColor = Colors.gray7.color
            joinButton.setTitleColor(Colors.gray4.color, for: .normal)
            joinButton.setTitle("모두 입력해주세요", for: .normal)
            deactivateTotalArea()
        } else {
            joinButton.backgroundColor = Colors.pointOrange.color
            joinButton.setTitleColor(.white, for: .normal)
            joinButton.setTitle("입력 완료", for: .normal)
            activateTotalArea()
        }
    }
    
    // MARK: - Service
    private func getTripData(inviteCode: String) {
        startLoading()
        JoinTripDataService.shared.getTripInfoWithInviteCode(inviteCode: inviteCode) { [weak self] (response) in
            switch(response)
            {
            case .success(let data):
                self?.rightCodeCheck(data as! JoinTripData)
            case .requestErr(let message):
                print(message)
                self?.endLoading()
            case .pathErr:
                self?.endLoading()
                PopupView.loadFromXib()
                    .setTitle("잘못된 참여코드입니다.")
                    .setDescription("다시 입력 해주세요.")
                    .setConfirmButton()
                    .present { event in
                        if event == .confirm {

                        }
                    }
            case .serverErr:
                self?.endLoading()
                PopupView.loadFromXib()
                    .setTitle("잘못된 참여코드입니다.")
                    .setDescription("다시 입력 해주세요.")
                    .setConfirmButton()
                    .present { event in
                        if event == .confirm {

                        }
                    }
            case .networkFail:
                self?.endLoading()
                PopupView.loadFromXib()
                    .setTitle("네트워크 에러입니다.")
                    .setConfirmButton()
                    .present { event in
                        if event == .confirm {

                        }
                    }
            }
        }
    }
    
    private func checkInviteCode() -> String {
        var inviteCode = ""
        codeTextField.forEach {
            if let code = $0.text {
                inviteCode += code
            }
        }
        return inviteCode
    }
    
    func rightCodeCheck(_ data: JoinTripData) {
        guard let vc = UIStoryboard(name: "CheckTripStoryboard", bundle: nil).instantiateViewController(identifier: "CheckTripViewController") as? CheckTripViewController else { return }
        vc.checkTripData = data
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - TextField Delegate

extension JoinTripViewController: UITextFieldDelegate {
    // MARK: - 숫자 1개만 입력 가능하도록 제한
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        /// textField 델리게이트에서 현재 input창에 입력된 값을 구하고 싶은 경우 - 글자 수 구하는 데 사용
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= 1
    }
}
