//
//  UIFont+Extension.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/06/29.
//

/*
 
 폰트 적용 방법
 
 1. 폰트 파일을 프로젝트에 넣는다.
    - 파일을 넣을 때 현재 프로젝트를 target으로 설정한다.
    - 해당 프로젝트에는 ios/Configuration/Font 폴더 내에 있음
 2. Info.plist에 폰트 정보를 추가한다.
    - Fonts provided by application 내에 확장자를 포함한 폰트 파일 이름을 입력한다.
 3. 폰트 이름 찾기
    - 등록하려는 폰트를 더블클릭하여 mac의 서체 관리자(Font Book)에 저장한다.
    - 서체 관리자에서 해당 폰트 정보를 눌러 PostScript 이름을 찾는다. (ex. NotoSansCJKkr-Medium)
 4. extension을 활용하여 swift 코드 내에서 편리하게 폰트를 적용한다.
    - ex. label.font = .NotoSans(.medium, size: 16)

 */

import UIKit

extension UIFont {
    public enum SpoqaHanSansNeoType: String {
        case bold = "Bold"
        case light = "Light"
        case medium = "Medium"
        case regular = "Regular"
        case thin = "Thin"
    }

    static func SpoqaHanSansNeo(_ type: SpoqaHanSansNeoType, size: CGFloat) -> UIFont {
        return UIFont(name: "SpoqaHanSansNeo-\(type.rawValue)", size: size)!
    }
}
