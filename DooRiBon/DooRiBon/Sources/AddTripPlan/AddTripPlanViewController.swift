//
//  AddTripPlanViewController.swift
//  DooRiBon
//
//  Created by 한상진 on 2021/07/05.
//

import UIKit

class AddTripPlanViewController: UIViewController {

    //MARK:- IBOutlet
    
    @IBOutlet weak var startTimeButton: UIButton!
    @IBOutlet weak var endTimeButton: UIButton!
    @IBOutlet weak var planTitleTextField: UITextField!
    @IBOutlet weak var planLocationTextField: UITextField!
    @IBOutlet weak var planMemoTextField: UITextField!
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeButtonSet()
        textFieldSet()
        // Do any additional setup after loading the view.
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

}

extension AddTripPlanViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.borderColor = Colors.pointBlue.color
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.borderColor = Colors.gray6.color
    }
}
