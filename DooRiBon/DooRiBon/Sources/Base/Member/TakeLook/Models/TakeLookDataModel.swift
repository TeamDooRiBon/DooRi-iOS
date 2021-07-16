//
//  TakeLookDataModel.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/16.
//

import Foundation

// MARK: - TakeLookResponse
struct TakeLookResponse: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: [TakeLookData]
}

// MARK: - TakeLookData
struct TakeLookData: Codable {
    let title: String
    let content: [TakeLookContent]
}

// MARK: - TakeLookContent
struct TakeLookContent: Codable {
    let answer: String
    let count: Int
}
