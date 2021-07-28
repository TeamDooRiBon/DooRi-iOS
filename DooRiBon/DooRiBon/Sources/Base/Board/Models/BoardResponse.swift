//
//  AddBoardResponse.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/14.
//

/*
 보드 추가 Response 형식
 */

import Foundation

// MARK: - AddBoardResponse
struct BoardResponse: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: [BoardData]?       // data는 실패하면 들어오지 않기 때문에 옵셔널 형태로 선언
}

// MARK: - AddBoardData
struct BoardData: Codable {
    let id, name, content: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, content
    }
}
