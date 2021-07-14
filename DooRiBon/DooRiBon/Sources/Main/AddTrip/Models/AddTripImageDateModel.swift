//
//  AddTripImageDateModel.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/13.
//

import Foundation
struct AddTripImageResponse: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: [String]
}
