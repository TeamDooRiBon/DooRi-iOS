//
//  TripViewController.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/06.
//

/*
 탭바의 경우 Base/ 안에 위치해있고
 - Member
 - Plan
 - Board
 - Store
 총 4개의 스토리보드와 뷰 컨트롤러가 연결되어 있습니다.
 각각의 뷰 컨트롤러에서 작업해주시면 됩니다.
 
 아이콘과 타이틀의 위치가 약간씩 조정하기 힘든 부분이 있어서
 디테일한 것은 나중에 수정하도록 하겠습니다.
 
 아이템 Inset의 경우 임의로 지정해놔서 수정필요 ✨
 */

import UIKit

class TripViewController: UITabBarController {
    
    // MARK: - Properties
    
    let appearance = UITabBarItem.appearance()
    var tripData: Group?

    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    // MARK: - Configure

    func configureUI() {
        navigationController?.navigationBar.isHidden = true
        
        // 그림자 세팅
        // - 기본 그림자 스타일 초기화
        // - top 그림자 적용
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: Colors.black2.color, alpha: 0.08, x: 0, y: -4, blur: 10)

        // 탭바 속 아이템 간격 조정
        tabBar.itemWidth = 88
        tabBar.itemPositioning = .centered
        
        let selectedColor   = Colors.pointBlue.color
        let unselectedColor = Colors.gray6.color
        
        // 아이템 색상 및 폰트 속성 조정
        appearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor,
                                           NSAttributedString.Key.font: UIFont.SpoqaHanSansNeo(.light, size: 12)], for: .normal)
        appearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor,
                                           NSAttributedString.Key.font: UIFont.SpoqaHanSansNeo(.regular, size: 12)], for: .selected)
        
        // 타이틀 위치 조정
        appearance.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 8)
    }
}

// MARK: - TabBar Extensions
extension UITabBar {
    // 기본 그림자 스타일을 초기화해야 커스텀 스타일을 적용할 수 있다.
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}

// MARK: - TabBar 높이 세팅 위한 클래스
class CustomTabBar : UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 82
        return sizeThatFits
    }
}
