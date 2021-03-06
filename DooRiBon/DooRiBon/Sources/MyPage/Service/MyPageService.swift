//
//  MyPageService.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/08/07.
//

import Foundation
import Alamofire

struct MyPageService
{
    static let shared = MyPageService()
    
    func getMyData(completion : @escaping (NetworkResult<Any>) -> Void)
    {
        let URL = APIConstants.myPageURL
        let header : HTTPHeaders = NetworkInfo.headerWithToken
        
        let dataRequest = AF.request(URL,
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
        guard let decodedData = try? decoder.decode(MyPageResponse.self, from: data)
        else { return .pathErr }
        
        switch statusCode {
        
        case 200: return .success(decodedData)
        case 400: return .pathErr
        case 500: return .serverErr
        default: return .networkFail
        }
    }
    
}
