//
//  MemberStyleDataModel.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/15.
//

import Foundation

// MARK: - Welcome
struct MemberStyleDataModel: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: DivisionMemberDataModel?
}

// MARK: - DataClass
struct DivisionMemberDataModel: Codable {
    let myResult: TripTendencyDataModel
    let othersResult: [TripTendencyDataModel]
}

// MARK: - Result
struct TripTendencyDataModel: Codable {
    let tag: [String]
    let id: String
    let member: ProfileDataModel
    let title: String
    let iOSResultImage, aOSResultImage, thumbnail: String

    enum CodingKeys: String, CodingKey {
        case tag
        case id = "_id"
        case member, title, iOSResultImage, aOSResultImage, thumbnail
    }
}

// MARK: - Member
struct ProfileDataModel: Codable {
    let id, name: String
    let profileImage: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, profileImage
    }
}
