//
//  NetworkInfo.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/13.
//

import Foundation

import Alamofire

enum NetworkHeaderKey: String {
    case auth = "x-auth-token"
    case contentType = "Content-Type"
}

struct NetworkInfo {
    static let shared = NetworkInfo()
    // 나중에는 카카오 로그인 처리 후에 UserDefault에 저장해놓은 token 값 사용
    static let token = APIConstants.jwtToken
    static var header: HTTPHeaders {
        [NetworkHeaderKey.contentType.rawValue: APIConstants.applicationJSON]
    }
    static var headerWithToken: HTTPHeaders {
        [
            NetworkHeaderKey.contentType.rawValue: APIConstants.applicationJSON,
            NetworkHeaderKey.auth.rawValue: token ?? ""
        ]
    }
}
