//
//  EditPlanDataModel.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/15.
//

import Foundation
struct EditPlanResponse: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: [EditPlaData]
}

// MARK: - Datum
struct EditPlaData: Codable {
    let id, startTime, formatTime, title: String
    let memo: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case startTime, formatTime, title, memo
    }
}
