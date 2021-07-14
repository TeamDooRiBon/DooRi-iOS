//
//  AddTripPlanDataModel.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/13.
//

import Foundation
struct AddTripPlanResponse: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: [AddTripPlanData]
}

// MARK: - Datum
struct AddTripPlanData: Codable {
    let id, startTime, formatTime, title: String
    let memo: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case startTime, formatTime, title, memo
    }
}
