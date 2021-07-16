//
//  GetMemberProfileDataService.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/14.
//

import Foundation
import Alamofire

struct GetMemberProfileDataService
{
    static let shared = GetMemberProfileDataService()
    
    func getPersonInfo(groupId: String, completion : @escaping (NetworkResult<Any>) -> Void)
    {
        let url = APIConstants.styleQuestionURL + "/\(groupId)"
        let header : HTTPHeaders = NetworkInfo.headerWithToken
        
        let dataRequest = AF.request(url,
                                     method: .get,
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { dataResponse in
            
            
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
            
            case .failure:
                completion(.pathErr)
                
            }
        }
                                            
    }
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(TakeLookResponse.self, from: data)
        else { return .pathErr }
        
        switch statusCode {

        case 200: return .success(decodedData.data?.members as Any)
        case 400: return .pathErr
        case 500: return .serverErr
        default: return .networkFail
        }
    }
}
