//
//  AddMemberDataModel.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/17.
//

import Foundation

// MARK: - Main
struct AddMemberResponse: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: AddMemberData?
}

// MARK: - DataClass
struct AddMemberData: Codable {
    let members: [MemberData]
    let id, schedules: String
    let boards, wishes, tendencies: JSONNull?
    let host, inviteCode, travelName, destination: String
    let startDate, endDate: String
    let image: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case members
        case id = "_id"
        case schedules, boards, wishes, tendencies, host, inviteCode, travelName, destination, startDate, endDate, image
        case v = "__v"
    }
}

// MARK: - Member
struct MemberData: Codable {
    let id, name: String
    let profileImage: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, profileImage
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
