//
//  addBackViewController.swift
//  myGYMapp
//
//  Created by MAC on 11/2/23.
//

import UIKit

protocol backProtocl {
    func sendBackData(proBackKind: String , proBackWeight: Double , proBackCount: Int , proBackSet: Int) //델🧪
}
class addBackViewController: UIViewController {
    
    var data01Array = [optionList]()
    var data02Array = [Double]()
    
    var backDelegate: backProtocl?
    
    @IBOutlet var backKindTextfield: UITextField!
    @IBOutlet var backWeightTextfield: UITextField!
    @IBOutlet var backCountTextfield: UITextField!
    @IBOutlet var backSetTextfield: UITextField!
    
    @IBOutlet var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backKindTextfield.placeholder = "EX : 데드리프트"
        self.backWeightTextfield.placeholder = "EX: 30"
        self.backCountTextfield.placeholder = "EX: 10"
        self.backSetTextfield.placeholder = "EX: 5"
        
        self.registerBtn.layer.cornerRadius = 30
        backKindTextfield.keyboardType = .default
        backWeightTextfield.keyboardType = .decimalPad
        backCountTextfield.keyboardType = .numberPad
        backSetTextfield.keyboardType = .numberPad
        
    }
    
    @IBAction func tapRegisterBtn(_ sender: UIButton) {
        if let kindField = backKindTextfield.text, !kindField.isEmpty,
           let WeightTextfield = backWeightTextfield.text, !WeightTextfield.isEmpty, let weightField = Double(WeightTextfield),
           let CountTextfield = backCountTextfield.text, !CountTextfield.isEmpty, let countField = Int(CountTextfield),
           let SetTextfield = backSetTextfield.text, !SetTextfield.isEmpty, let setField = Int(SetTextfield) {
            
            backDelegate?.sendBackData(proBackKind: kindField, proBackWeight: weightField, proBackCount: countField, proBackSet: setField)
            
            let data01 = optionList(kind: kindField, weight: weightField, count: countField, set: setField)
            let data02 = weightField * Double(countField) * Double(setField)
            
            let backData01 = data01Array.map{
                [
                    "kind":$0.kind ,
                    "weight":$0.weight ,
                    "count":$0.count ,
                    "set":$0.set
                ]
            }
            let backData02 = data02
            
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(backData01, forKey: "backData01")
            userDefaults.setValue(backData02, forKey: "backData02")
            
            self.navigationController?.popViewController(animated: true)
            print("addBackVC 에서 등록버튼이 눌렸다.")
            
        } else {
            return
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
