//
//  AddBoardRequest.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/14.
//

/*
 보드 추가 Body Request 형식
 */

import Foundation

struct AddBoardRequest: Encodable {
    var content: String
}
