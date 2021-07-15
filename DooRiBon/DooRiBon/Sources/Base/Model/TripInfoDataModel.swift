//
//  TripInformDataModel.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/15.
//

import Foundation
// MARK: - Tripd
struct TripInfoResponse: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: TripinfoData
}

// MARK: - DataClass
struct TripinfoData: Codable {
    let travelName: String
    let startDate: Date
    let endDate: Date
    let destination: String
    let members: [Member]
}

// MARK: - Member
struct Member: Codable {
    let name: String
    let profileImage: String
}
