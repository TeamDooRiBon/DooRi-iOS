//
//  GetMainDataService.swift
//  DooRiBon
//
//  Created by 민 on 2021/07/13.
//

import Foundation
import Alamofire

struct GetMainDataService
{
    static let shared = GetMainDataService()
    
    func getPersonInfo(completion : @escaping (NetworkResult<Any>) -> Void)
    {
        let URL = APIConstants.tripURL
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
        
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd-HH:mm"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(f)
        guard let decodedData = try? decoder.decode(MainDataModel.self, from: data)
        else { return .pathErr }
        
        switch statusCode {
        
        case 200: return .success(decodedData)
        case 400: return .pathErr
        case 500: return .serverErr
        default: return .networkFail
        }
    }
    
}
