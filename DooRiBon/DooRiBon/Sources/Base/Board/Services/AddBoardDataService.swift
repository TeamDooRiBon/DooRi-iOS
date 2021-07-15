//
//  AddBoardDataService.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/14.
//

import Foundation

import Alamofire

struct AddBoardDataService {
    // MARK: - 싱글턴 변수
    static let shared = AddBoardDataService()
    
    // MARK: - URL Create
    
    private func makeURL(groupId: String, tag: String) -> String {
        let url = APIConstants.postBoardURL
            .replacingOccurrences(of: ":groupId", with: groupId)
            .replacingOccurrences(of: ":tag", with: tag)
        return url
    }
    
    private func makeDeleteURL(groupId: String, tag: String, boardId: String) -> String {
        let url = APIConstants.boardURL + "/\(groupId)" + "/\(tag)" + "/\(boardId)"
        return url
    }
    
    // MARK: - Get Function
    
    func getTripBoard(groupId: String, tag: String, completion: @escaping (NetworkResult<Any>)->()) {
        let url = makeURL(groupId: groupId, tag: tag)
        let headers: HTTPHeaders = NetworkInfo.headerWithToken
        
        let dataRequest = AF.request(url,
                                     method: .get,
                                     encoding: JSONEncoding.default,
                                     headers: headers)
        
        dataRequest.responseData { (response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.value else { return }
                completion(judgeStatus(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    // MARK: - Post Function
    
    func postTripBoard(_ parameters: AddBoardRequest, groupId: String, tag: String, completion: @escaping (NetworkResult<Any>)->()) {
        let url = makeURL(groupId: groupId, tag: tag)
        let headers: HTTPHeaders = NetworkInfo.headerWithToken
        
        let dataRequest = AF.request(url,
                                     method: .post,
                                     parameters: parameters,
                                     encoder: JSONParameterEncoder(),
                                     headers: headers)
        
        dataRequest.responseData { (response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.value else { return }
                completion(judgeStatus(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    // MARK: - Delete Function
    
    func deleteTripBoard(groupId: String, tag: String, boardId: String, completion: @escaping (NetworkResult<Any>)->()) {
        let url = makeDeleteURL(groupId: groupId, tag: tag, boardId: boardId)
        let headers: HTTPHeaders = NetworkInfo.headerWithToken
        
        let dataRequest = AF.request(url,
                                     method: .delete,
                                     encoding: JSONEncoding.default,
                                     headers: headers)
        
        dataRequest.responseData { (response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.value else { return }
                completion(judgeStatus(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    // MARK: - Post Function
    
    func patchTripBoard(_ parameters: AddBoardRequest, groupId: String, tag: String, boardId: String, completion: @escaping (NetworkResult<Any>)->()) {
        let url = makeDeleteURL(groupId: groupId, tag: tag, boardId: boardId)
        let headers: HTTPHeaders = NetworkInfo.headerWithToken
        
        let dataRequest = AF.request(url,
                                     method: .patch,
                                     parameters: parameters,
                                     encoder: JSONParameterEncoder(),
                                     headers: headers)
        
        dataRequest.responseData { (response) in
            switch response.result {
            case .success:
                guard let statusCode = response.response?.statusCode else { return }
                guard let data = response.value else { return }
                completion(judgeStatus(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
                completion(.networkFail)
            }
        }
    }
    
    
    // MARK: - Judge Status
    
    private func judgeStatus(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(BoardResponse.self, from: data) else {return .pathErr}
        
        switch status {
        case 200: return .success(decodedData.data as Any)
        case 400..<500: return .requestErr(decodedData)
        case 500: return .serverErr
        default: return .networkFail
        }
    }
}
