//
//  TripTopView.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/09.
//

import UIKit

class TripTopView: UIView {
    // MARK: - IBOutlets
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var tripTitleLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var memberDescriptionLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var memberButton: UIButton!
    @IBOutlet weak var codeButton: UIButton!
    
    let xibName = "TripTopView"
    let formatter = DateFormatter()
    let calendar = Calendar.current
    private var startDate: Date?
    private var endDate: Date?
    private var tripData: Group?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    @IBAction private func copyCodeButtonClicked(_ sender: Any) {
        GetInviteCode.getInviteCode(groupID: tripData?._id ?? "")
    }
    

    private func commonInit(){
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func setTopViewData(tripData: Group) {
        self.tripData = tripData
        startDate = tripData.startDate
        endDate = tripData.endDate
        formatter.dateFormat = "yyyy.MM.dd"
        let start = formatter.string(from: tripData.startDate)
        formatter.dateFormat = "MM.dd"
        let end = formatter.string(from: tripData.endDate)
        
        periodLabel.text = "\(start) - \(end)"
        tripTitleLabel.text = tripData.travelName
        destinationLabel.text = tripData.destination
        memberDescriptionLabel.text = "\(tripData.members[0])님과 함께"
    }
}
