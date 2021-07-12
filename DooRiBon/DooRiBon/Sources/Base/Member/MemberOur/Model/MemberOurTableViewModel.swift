//
//  MemberOurTableViewModel.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/09.
//

import Foundation
struct MemberOurTableViewModel {
    var memberName: String
    var memberType: String
    var memberStyleOne: String
    var memberStyleTwo: String
    var memberStyleThree: String
    
    init(name: String, type: String, styleOne: String, styleTwo: String, styleThree: String) {
        self.memberName = name
        self.memberType = type
        self.memberStyleOne = styleOne
        self.memberStyleTwo = styleTwo
        self.memberStyleThree = styleThree
    }
}
