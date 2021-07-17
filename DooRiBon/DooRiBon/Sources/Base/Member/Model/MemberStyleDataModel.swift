//
//  MemberStyleDataModel.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/15.
//

import Foundation

// MARK: - Main
struct MemberStyleDataResponse: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: MeAndOtherDivision?
}

// MARK: - DataClass
struct MeAndOtherDivision: Codable {
    let myResult: MemberTestResultData?
    let othersResult: [MemberTestResultData]
}

// MARK: - Result
struct MemberTestResultData: Codable {
    let tag: [String]
    let id: String
    let member: MemberDetailData?
    let title, iOSResultImage, aOSResultImage, thumbnail: String

    enum CodingKeys: String, CodingKey {
        case tag
        case id = "_id"
        case member, title, iOSResultImage, aOSResultImage, thumbnail
    }
}

// MARK: - Member
struct MemberDetailData: Codable {
    let id, name: String
    let profileImage: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, profileImage
    }
}
