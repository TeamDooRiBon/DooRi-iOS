//
//  TripInformService.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/15.
//

import Foundation
import Alamofire

struct TripInformService
{
    static let shared = TripInformService()
    
    private func makeURL(groupID: String) -> String {
        let url = APIConstants.getTripInform.replacingOccurrences(of: ":groupId", with: groupID)
        return url
    }
    
    func getTripInfo(groupID : String,
                     completion : @escaping (NetworkResult<Any>) -> Void)
    {
        let url: String = makeURL(groupID: groupID)
        let header : HTTPHeaders = NetworkInfo.headerWithToken
        let dataRequest = AF.request(url,
                                     method: .get,
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
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd-HH:mm"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(f)
        guard let decodedData = try? decoder.decode(TripInfoResponse.self, from: data)
        else { return .pathErr }
        
        switch statusCode {
        
        case 200: return .success(decodedData)
        case 400: return .pathErr
        case 500: return .serverErr
        default: return .networkFail
        }
    }
    
}
