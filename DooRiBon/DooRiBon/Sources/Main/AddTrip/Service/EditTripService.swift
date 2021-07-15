//
//  EditTripService.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/15.
//

import Foundation
import Alamofire

struct EditTripService{
    static let shared = EditTripService()
    
    private func makeURL(groupID: String) -> String {
        let url = APIConstants.editTripURL.replacingOccurrences(of: ":groupId", with: groupID)
        return url
    }
    
    private func makeParameter(travelName : String, destination : String, startDate : String, endDate : String, imageIndex : Int) -> Parameters
    {
        return [
            "travelName" : travelName,
            "destination" : destination,
            "startDate" : startDate,
            "endDate" : endDate,
            "imageIndex" : imageIndex
        ]
    }
    
    func patchData(groupID : String,
                   travelName : String,
                   destination : String,
                   startDate : String,
                   endDate : String,
                   imageIndex : Int,
                   completion : @escaping (NetworkResult<Any>) -> Void)
    {
        let url: String = makeURL(groupID: groupID)
        let header : HTTPHeaders = NetworkInfo.headerWithToken
        let dataRequest = AF.request(url,
                                     method: .patch,
                                     parameters: makeParameter(travelName: travelName, destination: destination, startDate: startDate, endDate: endDate, imageIndex: imageIndex),
                                     encoding: JSONEncoding.default,
                                     headers: header)
        
        dataRequest.responseData { dataResponse in
            
            dump(dataResponse)
            switch dataResponse.result {
            case .success:
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
                let networkResult = self.judgeStatus(by: statusCode, value)
                print(statusCode)
                print(networkResult)
                completion(networkResult)
                
            case .failure: completion(.pathErr)
                
            }
        }
        
    }
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(EditTripResponse.self, from: data)
        else { return .pathErr}
        
        switch statusCode {
        case 200: return .success(decodedData)
        case 400: return .requestErr(decodedData)
        case 500: return .serverErr
        default: return .networkFail
        }
    }
}
