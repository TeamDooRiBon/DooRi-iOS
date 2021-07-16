//
//  EditPlanService.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/15.
//

import Foundation
import Alamofire

struct EditPlanService{
    static let shared = EditPlanService()
    
    private func makeURL(groupID: String, scheduleID: String) -> String {
        let groupUrl = APIConstants.editPlanURL.replacingOccurrences(of: ":groupId", with: groupID)
        let url = groupUrl.replacingOccurrences(of: ":scheduleId", with: scheduleID)
        return url
    }
    
    private func makeParameter(title : String, startTime : String, endTime : String, location : String, memo : String) -> Parameters
    {
        return [
            "title" : title,
            "startTime" : startTime,
            "endTime" : endTime,
            "location" : location,
            "memo" : memo
        ]
    }
    
    func patchData(groupID : String,
                   scheduleID : String,
                   title : String,
                   startTime : String,
                   endTime : String,
                   location : String,
                   memo : String,
                   completion : @escaping (NetworkResult<Any>) -> Void)
    {
        let url: String = makeURL(groupID: groupID, scheduleID: scheduleID)
        let header : HTTPHeaders = NetworkInfo.headerWithToken
        let dataRequest = AF.request(url,
                                     method: .patch,
                                     parameters: makeParameter(title: title, startTime: startTime, endTime: endTime, location: location, memo: memo),
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
        guard let decodedData = try? decoder.decode(EditPlanResponse.self, from: data)
        else { return .pathErr}
        
        switch statusCode {
        case 200: return .success(decodedData)
        case 400: return .requestErr(decodedData)
        case 500: return .serverErr
        default: return .networkFail
        }
    }
}
