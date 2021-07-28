//
//  LoginService.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/28.
//

import Foundation
import Alamofire

struct LoginService{
    static let shared = LoginService()
    
    private func makeParameter(accessToken : String, refreshToken : String) -> Parameters
    {
        return ["access_token" : accessToken,
                "refresh_token" : refreshToken
        ]
    }
    
    func kakaoLogin(accessToken : String,
                     refreshToken : String,
                     completion : @escaping (NetworkResult<Any>) -> Void)
    {
        let url: String = APIConstants.loginURL
        let header : HTTPHeaders = NetworkInfo.header
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: makeParameter(accessToken: accessToken, refreshToken: refreshToken),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        dataRequest.responseData { dataResponse in
            
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
        guard let decodedData = try? decoder.decode(LoginResponse.self, from: data)
        else { return .pathErr}
        switch statusCode {
        
        case 200: return .success(decodedData)
        case 400: return .requestErr(decodedData)
        case 500: return .serverErr
        default: return .networkFail
        }
    }
}
