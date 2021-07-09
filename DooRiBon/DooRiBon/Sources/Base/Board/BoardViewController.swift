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
}
