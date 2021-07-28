//
//  MemberProfileDataModel.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/14.
//
import Foundation

// MARK: - MemberProfileDataModel
struct MemberProfileDataModel: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: TripData
}

// MARK: - TripData
struct TripData: Codable {
    let travelName, startDate, endDate, destination: String
    let members: [Profile]
}

// MARK: - Profile
struct Profile: Codable {
    let name: String
    let profileImage: String
}
