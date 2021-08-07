//
//  MyPageDataModel.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/08/07.
//

import Foundation

// MARK: - MyPageResponse
struct MyPageResponse: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: MyPageData
}

// MARK: - DataClass
struct MyPageData: Codable {
    let name, email: String
    let image: String
    let tavelCount, tendencyCount: Int
}
