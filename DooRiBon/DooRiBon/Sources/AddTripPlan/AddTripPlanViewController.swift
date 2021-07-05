//
//  AddTripPlanViewController.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/05.
//

import UIKit
import SnapKit

class AddTripPlanViewController: UIViewController {

    //MARK:- IBOutlet
    
    /// Label
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    
    /// Button
    @IBOutlet weak var startTimeButton: UIButton!
    @IBOutlet weak var endTimeButton: UIButton!
    @IBOutlet weak var notCheckButton: UIButton!
    
    /// TextField
    @IBOutlet weak var planTitleTextField: UITextField!
    @IBOutlet weak var planLocationTextField: UITextField!
    @IBOutlet weak var planMemoTextField: UITextField!
    
    /// View
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var alphaView: UIView!
    
    //MARK:- Variable
    
    var selectCheck = false
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeButtonSet()
        textFieldSet()
//        testView.insertSubview(testView2, belowSubview: testView)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    //MARK:- IBAction
    
    @IBAction func notAddButtonClicked(_ sender: Any) {
        if !selectCheck {
            selectCheck = true
            notCheckButton.setImage(UIImage(named: "btnNotAddClicked"), for: .normal)
            planLocationTextField.isEnabled = false
            planLocationTextField.backgroundColor = Colors.gray7.color
            planLocationTextField.placeholder = ""
            planLocationTextField.text = ""
        } else {
            selectCheck = false
            notCheckButton.setImage(UIImage(named: "btnNotAdd"), for: .normal)
            planLocationTextField.isEnabled = true
            planLocationTextField.backgroundColor = Colors.white9.color
            planLocationTextField.placeholder = "Ex. 인천공항 이동하기"
        }
        
    }
    @IBAction func startTimeButtonClicked(_ sender: Any) {
        alphaView.alpha = 0.7
        alphaView.insertSubview(dateView, belowSubview: alphaView)
        let origImage = UIImage(named: "timeStartBoxline")
        let startTintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        startTimeButton.setImage(startTintedImage, for: .normal)
        startTimeButton.tintColor = Colors.pointBlue.color
        startDateLabel.textColor = Colors.pointBlue.color
        startTimeLabel.textColor = Colors.black1.color
        
        dateView.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(290)
            make.leading.equalToSuperview().offset(26)
        }
    }
    
    @IBAction func endTimeButtonClicked(_ sender: Any) {
        alphaView.alpha = 0.7
        alphaView.insertSubview(dateView, belowSubview: alphaView)
        let origImage = UIImage(named: "timeEndBoxline")
        
        let endTintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        endTimeButton.setImage(endTintedImage, for: .normal)
        endTimeButton.tintColor = Colors.pointBlue.color
        endDateLabel.textColor = Colors.pointBlue.color
        endTimeLabel.textColor = Colors.black1.color
        
        dateView.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(290)
            make.leading.equalToSuperview().offset(26)
        }
    }
    
    //MARK:- Function
    
    func textFieldSet() {
        planTitleTextField.delegate = self
        planLocationTextField.delegate = self
        planMemoTextField.delegate = self
    }
    
    func timeButtonSet() {
        var origImage = UIImage(named: "timeStartBoxline")
        
        let startTintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        startTimeButton.setImage(startTintedImage, for: .normal)
        startTimeButton.tintColor = Colors.gray6.color
        
        origImage = UIImage(named: "timeEndBoxline")
        let endTintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        endTimeButton.setImage(endTintedImage, for: .normal)
        endTimeButton.tintColor = Colors.gray6.color
    }

}

extension AddTripPlanViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.borderColor = Colors.pointBlue.color
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.borderColor = Colors.gray6.color
    }
}
