//
//  MainStyleTestService.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/16.
//

import Foundation
import Alamofire

struct MainStyleTestService{
    static let shared = MainStyleTestService()
    
    private func makeParameter(score: [Int]) -> Parameters
    {
        return ["score" : score]
    }
    
    func getData(score : [Int], completion : @escaping (NetworkResult<Any>) -> Void)
    {
        let url: String = APIConstants.styleTestMainURL
        let header : HTTPHeaders = NetworkInfo.headerWithToken
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: makeParameter(score: score),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        dataRequest.responseData { dataResponse in
            
            dump(dataResponse)
            
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
                let networkResult = self.judgeStatus(by: statusCode, value)
                completion(networkResult)
            case .failure: completion(.pathErr)
                
            }
        }
        
    }
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(MainStyleTestResponse.self, from: data)
        else { return .pathErr}
        switch statusCode {
        
        case 200: return .success(decodedData)
        case 400: return .requestErr(decodedData)
        case 500: return .serverErr
        default: return .networkFail
        }
    }
}
