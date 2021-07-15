//
//  StyleResultDataModel.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/14.
//

import Foundation
struct StyleResultResponse: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: StyleResultData
}

// MARK: - DataClass
struct StyleResultData: Codable {
    let member, title: String
    let tag: [String]
    let iOSResultImage, aOSResultImage, thumbnail: String
}
