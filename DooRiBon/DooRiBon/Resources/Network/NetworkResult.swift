//
//  NetworkResult.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/13.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
}
