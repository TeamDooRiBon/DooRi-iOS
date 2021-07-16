//
//  SplashViewController.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/15.
//

import UIKit

import Lottie
import SnapKit

class SplashViewController: UIViewController {
    // MARK: - View properties
    
    lazy var logoAnimationView: AnimationView = {
        let animationView = AnimationView(name: "logo_animation")
        animationView.frame = CGRect(x: 0, y: 0,
                                     width: 99, height: 99)
        animationView.contentMode = .scaleAspectFit
        animationView.stop()
        animationView.isHidden = true
        
        
        return animationView
    }()
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dooribon")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startSplashAnimation()
        setupUI()
        setConstraints()
    }
    
    // MARK: - Configure
    private func setupUI() {
        view.backgroundColor = Colors.pointBlue.color
        view.addSubview(logoAnimationView)
        view.addSubview(logoImageView)
    }
    
    private func setConstraints() {
        logoAnimationView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(241)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(99)
        }
        
        logoImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-65)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(99)
            $0.height.equalTo(14)
        }
    }
    
    
    
    private func startSplashAnimation() {
        logoAnimationView.isHidden = false
        logoAnimationView.play()
    }
}
