//
//  JoinTripDataModel.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/13.
//

/*
 여행 정보를 Response로 받아오는데 , 동일한 형태가 있으면 하나로 사용해도 괜찮을 듯
 {
     "status": 200,
     "success": true,
     "message": "참여 코드로 여행 찾기 성공",
     "data": {
         "groupId": "60ebfdfabc1ffc1325a15f22",
         "travelName": "배고픈 여행",
         "host": "채정아",
         "destination": "우리 집",
         "startDate": "2021-8-21-0:0",
         "endDate": "2021-8-24-0:0",
         "image": "https://dooribon.s3.ap-northeast-2.amazonaws.com/1.png"
     }
 }
 
 - 네이밍에 대한 고민
 */
import Foundation

// MARK: - JoinTrip 전체 데이터 모델
struct JoinTripResponse: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: JoinTripData?
}

// MARK: - JoinTrip 데이터
struct JoinTripData: Codable {
    let groupID, travelName, host, destination: String
    let startDate, endDate: String
    let image: String

    enum CodingKeys: String, CodingKey {
        case groupID = "groupId"
        case travelName, host, destination, startDate, endDate, image
    }
}
