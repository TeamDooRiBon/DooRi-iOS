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
    @IBOutlet weak var topLabel: UILabel!
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
    let pickerLabelDateformatter = DateFormatter()
    let postDataDateformatter = DateFormatter()
    var topLabelData: String = ""
    var buttonData: String = ""
    var groupID: String = ""
    var scheduleID: String = ""
    var startDate = "2021-07-05 16:30"
    var endDate = "2021-07-05 17:00"
    var startTime = "23:00"
    var endTime = "23:30"
    var currentDate: String = ""
    var day: String = ""
    var dateComponent = DateComponents()
    var initTitle: String = ""
    var initLocation: String = ""
    var initMemo: String = ""
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSet()
        textFieldSet()
        notificationSet()
        datePickerBackgroundViewSet()
        dateformatSet()
        dateSet()
        setAlphaView()
        initData()
        keyboardNoti()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        configureUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    //MARK:- Function
    func dateSet() {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_KR")
        f.dateFormat = "yyyy.MM.dd"
        let today = f.date(from: self.startDate)
        var cal = Calendar(identifier: .gregorian)         // 그레고리 캘린더 선언
        cal.locale = Locale(identifier: "ko_KR")
        let dateComponents = cal.dateComponents([.weekday], from: today!)
        guard let weekIndex = dateComponents.weekday else { return }
        let dayOfWeek = cal.weekdaySymbols[weekIndex-1]
        let strList = startDate.components(separatedBy: "-")
        day = "\(strList[0]).\(strList[1]).\(strList[2])(\(dayOfWeek.first!))"
        print(day)
        startDateLabel.text = day
        endDateLabel.text = day
    }
    
    func configureUI() {
        if topLabelData != "" {
            topLabel.text = topLabelData
            addNewPlanButton.setTitle(buttonData, for: .normal)
        }
    }
    
    func textFieldSet() {
        planTitleTextField.delegate = self
        planLocationTextField.delegate = self
        planMemoTextField.delegate = self
    }
    
    func buttonSet() {
        var origImage = UIImage(named: "timeStartBoxline")
        
        let startTintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        startTimeButton.setImage(startTintedImage, for: .normal)
        startTimeButton.tintColor = Colors.gray6.color
        
        origImage = UIImage(named: "timeEndBoxline")
        let endTintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        endTimeButton.setImage(endTintedImage, for: .normal)
        endTimeButton.tintColor = Colors.gray6.color
        
        addNewPlanButton.isEnabled = false
    }
    
    func notificationSet() {
        datePicker.addTarget(self, action: #selector(changed), for: .valueChanged)
    }
    
    func datePickerBackgroundViewSet() {
        datePickerBackgroundView.isHidden = true
        datePickerBackgroundView.alpha = 0
    }
    
    func dateformatSet() {
        pickerLabelDateformatter.dateStyle = .none
        pickerLabelDateformatter.timeStyle = .short
        pickerLabelDateformatter.locale = Locale(identifier: "ko")
        postDataDateformatter.dateFormat = "HH:mm"
    }
    
    func setAlphaView() {
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
    
    func initData() {
        planTitleTextField.text = initTitle
        planLocationTextField.text = initLocation
        planMemoTextField.text = initMemo
    }
    
    func keyboardNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - 키보드 높이 세팅
    @objc func keyboardWillShow(_ sender: Notification) {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        
        if height > 800 && height < 815 {
            self.view.frame.origin.y = -100
        } else if height < 800 {
            self.view.frame.origin.y = -160
        }
    }
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0
    }
    
    @objc func checking() {
        if !notAddCheck {
            if planTitleTextField.text != "" && planLocationTextField.text != "" && timeSelectCheck {
                addNewPlanButton.backgroundColor = Colors.pointOrange.color
                addNewPlanButton.setTitleColor(Colors.white8.color, for: .normal)
                addNewPlanButton.isEnabled = true
            } else {
                addNewPlanButton.backgroundColor = Colors.gray7.color
                addNewPlanButton.setTitleColor(Colors.gray4.color, for: .normal)
                addNewPlanButton.isEnabled = false
            }
        } else {
            if planTitleTextField.text != "" && timeSelectCheck {
                addNewPlanButton.backgroundColor = Colors.pointOrange.color
                addNewPlanButton.setTitleColor(Colors.white8.color, for: .normal)
                addNewPlanButton.isEnabled = true
            } else {
                addNewPlanButton.backgroundColor = Colors.gray7.color
                addNewPlanButton.setTitleColor(Colors.gray4.color, for: .normal)
                addNewPlanButton.isEnabled = false
            }
        }
    }
    
    @objc func changed(){
        let labelDate = pickerLabelDateformatter.string(from: datePicker.date)
        let postDate = postDataDateformatter.string(from: datePicker.date)
        if startEndCheck == 1 {
            startTimeLabel.text = labelDate
            startTime = postDate
        } else {
            endTimeLabel.text = labelDate
            endTime = postDate
        }
        checking()
    }
    
    @objc private func alphaViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideAlphaView()
        makeDateView()
    }
    
    //MARK:- IBAction
    @IBAction func backButtonClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
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
            notCheckButton.setImage(UIImage(named: "btnNotadd"), for: .normal)
            planLocationTextField.isEnabled = true
            planLocationTextField.backgroundColor = Colors.white9.color
            planLocationTextField.placeholder = "Ex. 인천공항 이동하기"
        }
        checking()
    }
    
    @IBAction func startTimeButtonClicked(_ sender: Any) {
        view.endEditing(true)
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
        view.endEditing(true)
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
    
    @IBAction func addNewPlanButtonClicked(_ sender: Any) {
        if topLabelData == "" {
            if let title = planTitleTextField.text, let location = planLocationTextField.text, let memo = planMemoTextField.text {
                AddTripPlanService.shared.addTripPlan(groupID: groupID, title: title, startTime: "\(startDate) \(startTime)", endTime: "\(startDate) \(endTime)", location: location, memo: memo) { result in
                    switch result {
                    case .success(_):
                        print("success")
                        self.navigationController?.popViewController(animated: true)
                    case .requestErr(_):
                        print("requestErr")
                    case .pathErr:
                        print("pathErr")
                    case .serverErr:
                        print("serverErr")
                    case .networkFail:
                        print("networkFail")
                    }
                }
            }
        } else {
            if let title = planTitleTextField.text, let location = planLocationTextField.text, let memo = planMemoTextField.text {
                EditPlanService.shared.patchData(groupID: groupID, scheduleID: scheduleID, title: title, startTime: "\(startDate) \(startTime)", endTime: "\(startDate) \(endTime)", location: location, memo: memo) { result in
                    switch result {
                    case .success(_):
                        print("success")
                        self.navigationController?.popViewController(animated: true)
                    case .requestErr(_):
                        print("requestErr")
                    case .pathErr:
                        print("pathErr")
                    case .serverErr:
                        print("serverErr")
                    case .networkFail:
                        print("networkFail")
                    }
                }
            }
        }
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
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checking()
    }
}
