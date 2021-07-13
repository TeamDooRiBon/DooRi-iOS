//
//  AddTripDataModel.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/13.
//

import Foundation
// MARK: - AddTrip
struct AddTripResponse: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: AddTripData?
}

// MARK: - DataClass
struct AddTripData: Codable {
    let inviteCode: String
}

