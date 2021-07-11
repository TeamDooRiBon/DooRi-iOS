//
//  DummyDataModel.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/10.
//

import Foundation

struct DummyDataModel {
    var imageName: String
    var message: String
    var description: String
    
    init(imageName: String,
         message: String,
         description: String) {
        self.imageName = imageName
        self.message = message
        self.description = description
    }
}
