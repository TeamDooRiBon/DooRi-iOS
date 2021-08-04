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
    static let token = APIConstants.jwtToken
    static var header: HTTPHeaders {
        [NetworkHeaderKey.contentType.rawValue: APIConstants.applicationJSON]
    }
    static var headerWithToken: HTTPHeaders {
        [
            NetworkHeaderKey.contentType.rawValue: APIConstants.applicationJSON,
            NetworkHeaderKey.auth.rawValue: String(decoding: token ?? Data(), as: UTF8.self)
        ]
    }
}
