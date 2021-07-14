//
//  ScheduleDataModel.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/15.
//

import Foundation

// MARK: - ScheduleResponse
struct ScheduleResponse: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: ScheduleData?
}

// MARK: - ScheduleData
struct ScheduleData: Codable {
    let id: String
    let writer: Writer
    let createdAt, tilte, startTime, endTime: String
    let location, memo: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case writer, createdAt, tilte, startTime, endTime, location, memo
    }
}

// MARK: - Writer
struct Writer: Codable {
    let name: String
    let profileImage: String
}
