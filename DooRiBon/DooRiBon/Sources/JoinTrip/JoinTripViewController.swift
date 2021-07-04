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
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var codeStackView: UIStackView!
    @IBOutlet var codeTextField: [UITextField]!
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureTextField()
    }
    
    
    // MARK: - IBActions
    @IBAction func joinTripButtonClicked(_ sender: Any) {
        
    }
}

// MARK: - Set up

extension JoinTripViewController {
    
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
    
}

// MARK: - TextField Delegate

extension JoinTripViewController: UITextFieldDelegate {
    
}
