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
    @IBOutlet weak var addTimeLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    /// Button
    @IBOutlet weak var startTimeButton: UIButton!
    @IBOutlet weak var endTimeButton: UIButton!
    @IBOutlet weak var notCheckButton: UIButton!
    @IBOutlet weak var addNewPlanButton: UIButton!
    
    /// TextField
    @IBOutlet weak var planTitleTextField: UITextField!
    @IBOutlet weak var planLocationTextField: UITextField!
    @IBOutlet weak var planMemoTextField: UITextField!
    
    /// View
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var alphaView: UIView!
    
    /// DatePicker
    @IBOutlet weak var datePickerBackgroundView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //MARK:- Variable
    
    var notAddCheck = false
    var startEndCheck = 1
    var timeSelectCheck = false
    let dateformatter = DateFormatter()
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeButtonSet()
        textFieldSet()
        notificationSet()
        datePickerBackgroundViewSet()
        dateformatSet()
        alphaViewSet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
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
    
    func notificationSet() {
        NotificationCenter.default.addObserver(self, selector: #selector(checking), name: UITextField.textDidChangeNotification, object: nil)
        datePicker.addTarget(self, action: #selector(changed), for: .valueChanged)
    }
    
    func datePickerBackgroundViewSet() {
        datePickerBackgroundView.isHidden = true
        datePickerBackgroundView.alpha = 0
    }
    
    func dateformatSet() {
        dateformatter.dateStyle = .none
        dateformatter.timeStyle = .short
        dateformatter.locale = Locale(identifier: "ko")
    }
    
    func alphaViewSet() {
        let alphaTap = UITapGestureRecognizer(target: self, action: #selector(alphaViewTapped(_:)))
        alphaView.addGestureRecognizer(alphaTap)
        alphaView.isUserInteractionEnabled = true
    }
    
    func hideAlphaView() {
        UIView.animate(withDuration: 0.5, animations: { [self] in
            alphaView.alpha = 0
            datePickerBackgroundView.isHidden = true
            view.layoutIfNeeded()
        })
        datePickerBackgroundView.alpha = 0
    }
    
    func makeDateView() {
        mainView.addSubview(dateView)
        dateView.snp.makeConstraints{ make in
            make.top.equalTo(addTimeLabel.snp.bottom).offset(11)
            make.leading.equalToSuperview().offset(25)
        }
        startTimeButton.tintColor = Colors.gray6.color
        startDateLabel.textColor = Colors.pointBlue.color
        startTimeLabel.textColor = Colors.black1.color
        endDateLabel.textColor = Colors.pointBlue.color
        endTimeLabel.textColor = Colors.black1.color
        endTimeButton.tintColor = Colors.gray6.color
    }
    
    func makeBottomDatePicker() {
        datePickerBackgroundView.snp.makeConstraints{ make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(30)
            make.height.equalTo(282)
        }
        
        datePicker.snp.makeConstraints{ make in
            make.left.equalTo(datePickerBackgroundView).offset(20)
            make.right.equalTo(datePickerBackgroundView).offset(-20)
            make.top.equalTo(datePickerBackgroundView.snp.top).offset(30)
            make.bottom.equalTo(datePickerBackgroundView).offset(-25)
        }
    }
    
    @objc func checking() {
        if !notAddCheck {
            if planTitleTextField.text != "" && planLocationTextField.text != "" && timeSelectCheck {
                addNewPlanButton.backgroundColor = Colors.pointOrange.color
                addNewPlanButton.setTitleColor(Colors.white8.color, for: .normal)
            } else {
                addNewPlanButton.backgroundColor = Colors.gray7.color
                addNewPlanButton.setTitleColor(Colors.gray4.color, for: .normal)
            }
        } else {
            if planTitleTextField.text != "" && timeSelectCheck {
                addNewPlanButton.backgroundColor = Colors.pointOrange.color
                addNewPlanButton.setTitleColor(Colors.white8.color, for: .normal)
            } else {
                addNewPlanButton.backgroundColor = Colors.gray7.color
                addNewPlanButton.setTitleColor(Colors.gray4.color, for: .normal)
            }
        }
    }
    
    @objc func changed(){
        let date = dateformatter.string(from: datePicker.date)
        if startEndCheck == 1 {
            startTimeLabel.text = date
        } else {
            endTimeLabel.text = date
        }
        checking()
    }
    
    @objc private func alphaViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideAlphaView()
        makeDateView()
    }
    
    //MARK:- IBAction
    
    @IBAction func notAddButtonClicked(_ sender: Any) {
        if !notAddCheck {
            notAddCheck = true
            notCheckButton.setImage(UIImage(named: "btnNotAddClicked"), for: .normal)
            planLocationTextField.isEnabled = false
            planLocationTextField.backgroundColor = Colors.gray7.color
            planLocationTextField.placeholder = ""
            planLocationTextField.text = ""
        } else {
            notAddCheck = false
            notCheckButton.setImage(UIImage(named: "btnNotAdd"), for: .normal)
            planLocationTextField.isEnabled = true
            planLocationTextField.backgroundColor = Colors.white9.color
            planLocationTextField.placeholder = "Ex. 인천공항 이동하기"
        }
        checking()
    }
    
    @IBAction func startTimeButtonClicked(_ sender: Any) {
        datePickerBackgroundView.isHidden = false
        alphaView.insertSubview(dateView, belowSubview: alphaView)
        UIView.animate(withDuration: 0.5, animations: { [self] in
            datePickerBackgroundView.alpha = 1
            alphaView.alpha = 0.7
            timeSelectCheck = true
            startEndCheck = 1
            
            startTimeButton.tintColor = Colors.pointBlue.color
            startDateLabel.textColor = Colors.pointBlue.color
            startTimeLabel.textColor = Colors.black1.color
            
            dateView.snp.makeConstraints{ make in
                make.top.equalToSuperview().offset(290)
                make.leading.equalToSuperview().offset(25)
            }
            endTimeButton.tintColor = Colors.gray6.color
            endDateLabel.textColor = Colors.gray5.color
            endTimeLabel.textColor = Colors.gray5.color
            makeBottomDatePicker()
        })
        checking()
    }
    
    @IBAction func endTimeButtonClicked(_ sender: Any) {
        datePickerBackgroundView.isHidden = false
        alphaView.insertSubview(dateView, belowSubview: alphaView)
        UIView.animate(withDuration: 0.5, animations: { [self] in
            datePickerBackgroundView.alpha = 1
            alphaView.alpha = 0.7
            timeSelectCheck = true
            startEndCheck = 2
            
            endTimeButton.tintColor = Colors.pointBlue.color
            endDateLabel.textColor = Colors.pointBlue.color
            endTimeLabel.textColor = Colors.black1.color
            
            dateView.snp.makeConstraints{ make in
                make.top.equalToSuperview().offset(290)
                make.leading.equalToSuperview().offset(25)
            }
            startTimeButton.tintColor = Colors.gray6.color
            startDateLabel.textColor = Colors.gray5.color
            startTimeLabel.textColor = Colors.gray5.color
            makeBottomDatePicker()
        })
        checking()
    }
}

//MARK:- Extension

extension AddTripPlanViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.borderColor = Colors.pointBlue.color
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.borderColor = Colors.gray6.color
    }
}
