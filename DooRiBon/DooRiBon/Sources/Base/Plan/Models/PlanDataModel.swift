//
//  PlanDataModel.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/07.
//

import Foundation

struct PlanDataModel {
    var planTime: String
    var planTitle: String
    var planDescription: String
    
    init(planTime: String,
         planTitle: String,
         planDescription: String) {
        self.planTime = planTime
        self.planTitle = planTitle
        self.planDescription = planDescription
    }
}

