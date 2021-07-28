//
//  GetInviteCode.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/16.
//

import UIKit

class GetInviteCode {
    static func getInviteCode(groupID: String) {
        TripInformService.shared.getTripInfo(groupID: groupID) { (response) in
            switch(response)
            {
            case .success(let data):
                if let trip = data as? TripInfoResponse {
                    UIPasteboard.general.string = trip.data.inviteCode
                }
            case .requestErr(let message):
                print("requestERR", message)
            case .pathErr:
                print("pathERR")
            case .serverErr:
                print("serverERR")
            case .networkFail:
                print("networkERR")
            }
        }
    }
}


