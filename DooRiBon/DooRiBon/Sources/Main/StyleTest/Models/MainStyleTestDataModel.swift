//
//  MainStyleTestDataModel.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/16.
//

import Foundation

struct MainStyleTestResponse: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: MainStyleTestData?
}

// MARK: - DataClass
struct MainStyleTestData: Codable {
    let member, title: String
    let tag: [String]
    let iOSResultImage, aOSResultImage, thumbnail: String
}
