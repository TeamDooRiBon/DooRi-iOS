//
//  EditTripDataModel.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/15.
//

import Foundation
struct EditTripResponse: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: EditTripData
}

// MARK: - DataClass
struct EditTripData: Codable {
    let travelName, destination, startDate, endDate: String
    let image: String
}
