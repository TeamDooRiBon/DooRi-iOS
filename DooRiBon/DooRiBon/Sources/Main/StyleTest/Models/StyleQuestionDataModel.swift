//
//  AnswerDataModel.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/12.
//

import Foundation

struct StyleQuestionResponse: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: [StyleQuestionData]
}

// MARK: - Datum
struct StyleQuestionData: Codable {
    let title: String
    let content: [StyleQuestionAnswerWeight]
}

// MARK: - Content
struct StyleQuestionAnswerWeight: Codable {
    let answer: String
    let weight: [Int]
}
