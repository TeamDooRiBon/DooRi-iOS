//
//  MemberCodeCopyTableViewCell.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/11.
//

import UIKit

class MemberCodeCopyTableViewCell: UITableViewCell {
    var groupID: String = ""
    var inviteCode: String = ""
    @IBOutlet weak var informLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        informLabelSet()
    }
    
    func informLabelSet() {
        informLabel.text = "아직 진행된 TEST가 없어요\n일행에게 참여코드를 공유하여 여행 유형을 비교해보세요!"
    }
    
    @IBAction func codeCopyButtonClicked(_ sender: Any) {
        getInviteCode()
        ToastView
            .show("참여코드 복사 완료! 원하는 곳에 붙여넣기 하세요.")
    }
    
    func getInviteCode() {
        TripInformService.shared.getTripInfo(groupID: groupID) { [self] (response) in
            switch(response)
            {
            case .success(let data):
                if let trip = data as? TripInfoResponse {
                    inviteCode = trip.data.inviteCode
                    UIPasteboard.general.string = inviteCode
                }
                print(inviteCode)
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
