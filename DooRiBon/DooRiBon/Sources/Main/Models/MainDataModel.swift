//
//  MainDataModel.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/13.
//

import Foundation

// MARK: - Welcome
struct MainDataModel: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: [Trip]?
}

// MARK: - Datum
struct Trip: Codable {
    let when: String
    let group: [Group]
}

// MARK: - Group
struct Group: Codable {
    let id, startDate, endDate, travelName: String
    let image: String
    let destination: String
    let members: [String]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case startDate, endDate, travelName, image, destination, members
    }
}
