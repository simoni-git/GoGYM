//
//  addShoulderViewController.swift
//  myGYMapp
//
//  Created by MAC on 11/3/23.
//

import UIKit

protocol shoulderProtocol {
    func sendShoulderData(proShoulderKind: String , proShoulderWeight: Double , proShoulderCount: Int , proShoulderSet: Int) //델🧪
}
class addShoulderViewController: UIViewController {
    
    var data01Array = [optionList]()
    var data02Array = [Double]()
    
    var shoulderDelegate: shoulderProtocol?
    
    @IBOutlet var shoulderKindTextfield: UITextField!
    @IBOutlet var shoulderWeightTextfield: UITextField!
    @IBOutlet var shoulderCountTextfield: UITextField!
    @IBOutlet var shoulderSetTextfield: UITextField!
    
    @IBOutlet var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.shoulderKindTextfield.placeholder = "EX : 밀리터리프레스"
        self.shoulderWeightTextfield.placeholder = "EX: 30"
        self.shoulderCountTextfield.placeholder = "EX: 10"
        self.shoulderSetTextfield.placeholder = "EX: 5"
        
        self.registerBtn.layer.cornerRadius = 30
        shoulderKindTextfield.keyboardType = .default
        shoulderWeightTextfield.keyboardType = .decimalPad
        shoulderCountTextfield.keyboardType = .numberPad
        shoulderSetTextfield.keyboardType = .numberPad
    }
    
    @IBAction func tapRegisterBtn(_ sender: UIButton) {
        if let kindField = shoulderKindTextfield.text, !kindField.isEmpty,
           let WeightTextfield = shoulderWeightTextfield.text, !WeightTextfield.isEmpty, let weightField = Double(WeightTextfield),
           let CountTextfield = shoulderCountTextfield.text, !CountTextfield.isEmpty, let countField = Int(CountTextfield),
           let SetTextfield = shoulderSetTextfield.text, !SetTextfield.isEmpty, let setField = Int(SetTextfield) {
            
            shoulderDelegate?.sendShoulderData(proShoulderKind: kindField, proShoulderWeight: weightField, proShoulderCount: countField, proShoulderSet: setField)
            
            let data01 = optionList(kind: kindField, weight: weightField, count: countField, set: setField)
            let data02 = weightField * Double(countField) * Double(setField)
            
            let shoulderData01 = data01Array.map{
                [
                    "kind":$0.kind ,
                    "weight":$0.weight ,
                    "count":$0.count ,
                    "set":$0.set
                ]
            }
            let shoulderData02 = data02
            
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(shoulderData01, forKey: "shoulderData01")
            userDefaults.setValue(shoulderData02, forKey: "shoulderData02")
            
            self.navigationController?.popViewController(animated: true)
            print("addShoulderVC 에서 등록버튼이 눌렸다.")
            
        } else {
            return
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
