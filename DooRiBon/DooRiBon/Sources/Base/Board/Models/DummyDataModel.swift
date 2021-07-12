//
//  DummyDataModel.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/10.
//

import Foundation

struct DummyDataModel {
    var titleName: String
    var imageName: String
    var message: String
    var description: String
    
    init(titleName: String,
         imageName: String,
         message: String,
         description: String) {
        self.titleName = titleName
        self.imageName = imageName
        self.message = message
        self.description = description
    }
}
