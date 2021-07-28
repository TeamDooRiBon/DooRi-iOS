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
    
    static let jwtToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7ImlkIjoiNjBmMWRkYTA0N2IzOTIyMDJjY2RjMDQ0In0sImlhdCI6MTYyNjg0NTY5NywiZXhwIjoxNjI3MjA1Njk3fQ.grPcs4IC2IsTkfrCsWUIykGbeohlj7GOtHcGhN4oP1I"
    
    // MARK: - URLs
    
    // Base URL
    static let baseURL = "http://13.209.82.176:5000"

    // MARK: - /travel URLs
    static let tripURL = baseURL + "/travel"
    static let inviteCodeURL = baseURL + "/travel/group/:inviteCode"    // 여행 참여, 여행 정보 조회
    static let addTripURL = baseURL + "/travel" // 여행 생성 뷰 post
    static let addTripImageURL = baseURL + "/image" // 여행 생성 뷰 이미지 호출
    static let editTripURL = baseURL + "/travel/:groupId" // 여행 데이터 편집
    static let getTripInform = baseURL + "/travel/:groupId"
    static let addMemberURL = baseURL + "/travel/:groupId"

    // MARK: - /auth/user URLs
    
    // MARK: - /schedule
    static let getSpecificDateURL = baseURL + "/schedule/daily/:groupId/:date"
    static let addPlanURL = baseURL + "/schedule/:groupId"
    static let scheduleURL = baseURL + "/schedule"
    static let getScheduleURL = baseURL + "/schedule/:groupId/:scheduleId"
    static let editPlanURL = baseURL + "/schedule/:groupId/:scheduleId"

    // MARK: - /board
    static let boardURL = baseURL + "/board"
    static let postBoardURL = baseURL + "/board/:groupId/:tag"          // 여행 보드 추가
    
    // MARK: - /tendency
    static let styleURL = baseURL + "/tendency"
    static let styleQuestionURL = baseURL + "/tendency/question"
    static let styleResultSaveURL = baseURL + "/tendency/:groupId"
    static let styleTestMainURL = baseURL + "/tendency/result/main"
    
    // MARK: - /image
    
    // MARK: - /user/myPage

}

    // MARK: - URLs
