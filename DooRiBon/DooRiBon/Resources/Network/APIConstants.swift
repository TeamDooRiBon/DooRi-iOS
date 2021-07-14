//
//  APIConstants.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/06/29.
//

// MARK: 해당 파일 안에는 API 관련 상수들을 추가해주세요!!
// - 싱글턴으로 변수를 생성해주세요.
// - ex. static let baseURL = "https://www.example.com"
struct APIConstants {
    // MARK: - Headers
    
    static let authorization = "Authorization"
    static let accept = "Accept"
    static let auth = "x-auth-token"
    static let contentType = "Content-Type"

    // MARK: - Values
    
    static let applicationJSON = "application/json"
    static let formEncoded = "application/x-www-form-urlencoded"

    // MARK: - Keys
    
    static let jwtToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7ImlkIjoiNjBlYzY5ZTQ2MmU3YzhiYzU4YWEwMjM3In0sImlhdCI6MTYyNjEwNjM0MCwiZXhwIjoxNjI2NDY2MzQwfQ.WhyVGeI9V9LaOpgXg71rqiCdSTE42jbP9YxpA1i2Ap4"
    
    // MARK: - URLs
    
    // Base URL
    static let baseURL = "http://13.209.82.176:5000"
    
    // MARK: - /travel URLs
    static let tripURL = baseURL + "/travel"
    static let inviteCodeURL = baseURL + "/travel/group/:inviteCode"    // 여행 참여, 여행 정보 조회
    
    // MARK: - /auth/user URLs
    
    // MARK: - /schedule
    static let getSpecificDateURL = baseURL + "/schedule/daily/:groupId/:date"

    // MARK: - /board
    static let postBoardURL = baseURL + "/board/:groupId/:tag"          // 여행 보드 추가
    
    // MARK: - /tendency
    
    // MARK: - /image
    
    // MARK: - /user/myPage
}

    // MARK: - URLs
