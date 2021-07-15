//
//  ScheduleDataService.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/15.
//

import Foundation

import Alamofire

struct ScheduleDataService {
    // MARK: - 싱글턴 변수
    static let shared = ScheduleDataService()
    
    // MARK: - URL Create
    
    private func makeURL(groupId: String, scheduleId: String) -> String {
        let url = APIConstants.scheduleURL + "/\(groupId)" + "/\(scheduleId)"
        return url
    }
    
    // MARK: - Get Function
    
    func getSchedule(groupId: String, scheduleId: String, completion: @escaping (NetworkResult<Any>)->()) {
        let url = makeURL(groupId: groupId, scheduleId: scheduleId)
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
                
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    // MARK: - Judge Status
    
    private func judgeStatus(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(ScheduleResponse.self, from: data) else {return .pathErr}
        
        switch status {
        case 200: return .success(decodedData.data as Any)
        case 400..<500: return .requestErr(decodedData)
        case 500: return .serverErr
        default: return .networkFail
        }
    }
}
