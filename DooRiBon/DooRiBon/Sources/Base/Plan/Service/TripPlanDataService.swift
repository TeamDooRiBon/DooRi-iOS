//
//  TripPlanDataService.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/14.
//

import Foundation

import Alamofire

struct TripPlanDataService {
    // MARK: - 싱글턴 변수
    static let shared = TripPlanDataService()
    
    // MARK: - URL Create
    
    private func makeURL(groupId: String, date: String) -> String {
        let url = APIConstants.getSpecificDateURL
            .replacingOccurrences(of: ":groupId", with: groupId)
            .replacingOccurrences(of: ":date", with: date)
        return url
    }
    
    // MARK: - Get Function
    
    func getTripPlan(groupId: String, date: String, completion: @escaping (NetworkResult<Any>)->()) {
        let url = makeURL(groupId: groupId, date: date)
        let headers: HTTPHeaders = NetworkInfo.headerWithToken
        
        let dataRequest = AF.request(url,
                                     method: .get,
                                     encoding: JSONEncoding.default,
                                     headers: headers)
        
        dataRequest.responseData { (response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.value else { return }
                completion(judgeStatus(status: statusCode, data: data))
                
            case .failure(_):
                completion(.networkFail)
            }
        }
    }
    
    // MARK: - Judge Status
    
    private func judgeStatus(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(TripPlanResponse.self, from: data) else {return .pathErr}
        
        switch status {
        case 200: return .success(decodedData.data?.schedules as Any)
        case 400..<500: return .requestErr(decodedData)
        case 500: return .serverErr
        default: return .networkFail
        }
    }
}
