//
//  AddTripService.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/13.
//

import Foundation
import Alamofire

struct AddTripService{
    static let shared = AddTripService()
    
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
    
    func postData(travelName : String,
               destination : String,
               startDate : String,
               endDate : String,
               imageIndex : Int,
               completion : @escaping (NetworkResult<Any>) -> Void)
    {
        let header : HTTPHeaders = NetworkInfo.headerWithToken
        let dataRequest = AF.request(APIConstants.addTripURL,
                                     method: .post,
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
                print(networkResult)
                completion(networkResult)
                
            case .failure: completion(.pathErr)
                
            }
        }
        
    }
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(AddTripResponse.self, from: data)
        else { return .pathErr}
        
        switch statusCode {
        case 200: return .success(decodedData)
        case 400: return .requestErr(decodedData)
        case 500: return .serverErr
        default: return .networkFail
        }
    }
}
