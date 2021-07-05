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
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var codeStackView: UIStackView!
    @IBOutlet var codeTextField: [UITextField]!
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTextField()
        registerNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// Activate Area
        activateCodeInputArea(index: currentIndex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // 옵저버 해제
        unregisterNotifications()
    }
    
    // MARK: - IBActions
    @IBAction func joinTripButtonClicked(_ sender: Any) {
        
    }
}

// MARK: - Set up

extension JoinTripViewController {
    
    // MARK: - Configure
    
    private func configureUI() {
        /// Navigation Controller
        navigationController?.navigationBar.isHidden = true
        
        /// Shadow
        for codeUIView in codeStackView.arrangedSubviews {
            codeUIView.layer.applyShadow(color: .black,
                                         alpha: 0.07,
                                         x: 0,
                                         y: 3,
                                         blur: 10,
                                         spread: 0)
        }
        
    }
    
    private func configureTextField() {
        
        for (index, textField) in codeTextField.enumerated() {
            textField.tintColor = .clear
            textField.delegate = self
            textField.tag = index
        }

    }
    
    // MARK: - Private Functions
    
    private func activateCodeInputArea(index: Int) {
        codeStackView.arrangedSubviews[index].backgroundColor = Colors.backgroundBlue.color
        codeStackView.arrangedSubviews[index].borderWidth = 1
        codeStackView.arrangedSubviews[index].borderColor = Colors.subBlue1.color
        
        codeTextField[index].becomeFirstResponder()
    }
    
    private func deactivateCodeInputArea(index: Int) {
        codeStackView.arrangedSubviews[index].backgroundColor = Colors.white9.color
        codeStackView.arrangedSubviews[index].borderColor = .clear

        codeTextField[index].resignFirstResponder()
    }
}

    private func deactivateTotalArea() {
        codeStackView.arrangedSubviews.forEach {
            $0.layer.borderColor = UIColor.clear.cgColor
        }
        activateCodeInputArea(index: currentIndex)
    }
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(checkTextField), name: UITextField.textDidChangeNotification, object: nil)
    }
    private func unregisterNotifications() {
        // self에 등록된 옵저버 전체 해제
        NotificationCenter.default.removeObserver(self)
    }
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
// MARK: - TextField Delegate

extension JoinTripViewController: UITextFieldDelegate {
    
    // MARK: - 숫자 1개만 입력 가능하도록 제한
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        /// 숫자만 입력 가능하도록 - 사실 이 코드는 없어도 될 거라고 생각은 하지만 최대한 안전하게
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        /// textField 델리게이트에서 현재 input창에 입력된 값을 구하고 싶은 경우 - 글자 수 구하는 데 사용
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
        
        return allowedCharacters.isSuperset(of: characterSet) && newString.length <= 1
    }
}
