//
//  LoginDataModel.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/28.
//

import Foundation

// MARK: - LoginResponse
struct LoginResponse: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: LoginData
}

// MARK: - DataClass
struct LoginData: Codable {
    let user: UserData
    let token, accessToken, refreshToken: String

    enum CodingKeys: String, CodingKey {
        case user, token
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

// MARK: - User
struct UserData: Codable {
    let groups: [String]
    let id, name, email: String
    let profileImage: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case groups
        case id = "_id"
        case name, email, profileImage
        case v = "__v"
    }
}
