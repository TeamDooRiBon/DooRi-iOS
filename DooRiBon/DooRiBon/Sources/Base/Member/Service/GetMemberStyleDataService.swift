//
//  GetMemberStyleDataService.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/15.
//

import Foundation
import Alamofire

struct GetMemberStyleDataService {
    // MARK: - 싱글턴 변수
    static let shared = GetMemberStyleDataService()
    
    // MARK: - URL Create
    
    private func makeURL(groupId: String) -> String {
        let url = APIConstants.styleURL + "/\(groupId)"
        return url
    }
    
    // MARK: - Get Function
    
    func getMemberStyle(groupId: String, completion: @escaping (NetworkResult<Any>)->()) {
        let url = makeURL(groupId: groupId)
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
                completion(judgeGetStatus(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    
    // MARK: - Judge Status
    
    private func judgeGetStatus(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(MemberStyleDataModel.self, from: data) else {return .pathErr}
        
        switch status {
        case 200: return .success(decodedData.data as Any)
        case 400..<500: return .requestErr(decodedData)
        case 500: return .serverErr
        default: return .networkFail
        }
    }
    
}
