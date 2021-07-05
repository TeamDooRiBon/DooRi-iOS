//
//  CodeTextField.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/04.
//

import UIKit

class CodeTextField: UITextField {
    // MARK: - Properties
    var backspaceCalled: (() -> ())?
    
    // 키보드 back button 클릭시
    override func deleteBackward() {
        backspaceCalled?()
        super.deleteBackward()
    }
}
