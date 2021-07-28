//
//  AddMemberService.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/17.
//

import Foundation
import Alamofire

struct AddMemberService{
    static let shared = AddMemberService()
    
    private func makeURL(groupID: String) -> String {
        let url = APIConstants.addMemberURL.replacingOccurrences(of: ":groupId", with: groupID)
        return url
    }
    
    func addMember(groupID : String,
                     completion : @escaping (NetworkResult<Any>) -> Void)
    {
        let url: String = makeURL(groupID: groupID)
        let header : HTTPHeaders = NetworkInfo.headerWithToken
        let dataRequest = AF.request(url,
                                     method: .post,
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
        guard let decodedData = try? decoder.decode(AddMemberResponse.self, from: data)
        else { return .pathErr}
        switch statusCode {
        
        case 200: return .success(decodedData)
        case 400: return .requestErr(decodedData)
        case 500: return .serverErr
        default: return .networkFail
        }
    }
}
