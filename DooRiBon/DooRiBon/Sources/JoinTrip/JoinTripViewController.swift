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
            activateCodeInputArea(index: currentIndex)
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// Activate Area
        activateCodeInputArea(index: currentIndex)
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
        codeTextField.forEach {
            /// 커서 안 깜빡이게 하기 (클리어)
            $0.tintColor = .clear
            $0.delegate = self
        }
    }
    
    // MARK: - Private Functions
    
    private func activateCodeInputArea(index: Int) {
        codeStackView.arrangedSubviews[index].backgroundColor = Colors.backgroundBlue.color
        codeStackView.arrangedSubviews[index].borderWidth = 1
        codeStackView.arrangedSubviews[index].borderColor = Colors.subBlue1.color
    }
    
    private func deactivateCodeInputArea(index: Int) {
        codeStackView.arrangedSubviews[index].backgroundColor = Colors.white9.color
        codeStackView.arrangedSubviews[index].borderColor = .clear
    }
}

// MARK: - TextField Delegate

extension JoinTripViewController: UITextFieldDelegate {
    
}
