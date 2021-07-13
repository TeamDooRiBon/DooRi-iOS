//
//  JoinTripDataService.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/13.
//

import Foundation

import Alamofire

struct JoinTripDataService {
    // MARK: - 싱글톤 변수
    
    static let shared = JoinTripDataService()
    
    // MARK: - API 요청 함수
    
    func getTripInfoWithInviteCode(completion: @escaping (NetworkResult<Any>)->()) {
        
        let url: String = APIConstants.inviteCodeURL            // URL
        let header: HTTPHeaders = NetworkInfo.headerWithToken   // Headers
        
        let dataRequest = AF.request(url,
                                     method: .get,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { (response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.value else { return }
                
                print("😁 \(statusCode)")
                print("💽 \(data)")
                    
                completion(judgeStatus(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    // MARK: - Judge Function
    
    private func judgeStatus(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(JoinTripData.self, from: data) else {return .pathErr}
        
        switch status {
        case 200: return .success(decodedData)
        case 400..<500: return .requestErr(decodedData)
        case 500: return .serverErr
        default: return .networkFail
        }
    }
}
