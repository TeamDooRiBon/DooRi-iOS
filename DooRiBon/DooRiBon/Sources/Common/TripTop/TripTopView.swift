//
//  TripTopView.swift
//  DooRiBon
//
//  Created by taehy.k on 2021/07/09.
//

import UIKit

class TripTopView: UIView {
    // MARK: - IBOutlets
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var memberButton: UIButton!
    @IBOutlet weak var codeButton: UIButton!
    
    let xibName = "TripTopView"

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit(){
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
}
