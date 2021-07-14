//
//  TripPlanDataModel.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/14.
//

import Foundation

// MARK: - Welcome
struct TripPlanResponse: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: TripPlanData?
}

// MARK: - DataClass
struct TripPlanData: Codable {
    let day: Int
    let date: String
    let schedules: [Schedule]?
}

// MARK: - Schedule
struct Schedule: Codable {
    let id, startTime, formatTime, title: String
    let memo: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case startTime, formatTime, title, memo
    }
}
