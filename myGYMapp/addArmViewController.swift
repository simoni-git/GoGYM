//
//  addArmViewController.swift
//  myGYMapp
//
//  Created by MAC on 11/3/23.
//

import UIKit

protocol armProtocol {
    func sendArmData(proArmKind: String , proArmWeight: Double , proArmCount: Int , proArmSet: Int) //델🧪
}
class addArmViewController: UIViewController {
    
    var data01Array = [optionList]()
    var data02Array = [Double]()
    
    var armDelegate: armProtocol?
    
    @IBOutlet var armKindTextfield: UITextField!
    @IBOutlet var armWeightTextfield: UITextField!
    @IBOutlet var armCountTextfield: UITextField!
    @IBOutlet var armSetTextfield: UITextField!
    
    @IBOutlet var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.armKindTextfield.placeholder = "EX : 바벨컬"
        self.armWeightTextfield.placeholder = "EX: 10"
        self.armCountTextfield.placeholder = "EX: 10"
        self.armSetTextfield.placeholder = "EX: 5"
        
        self.registerBtn.layer.cornerRadius = 30
        armKindTextfield.keyboardType = .default
        armWeightTextfield.keyboardType = .decimalPad
        armCountTextfield.keyboardType = .numberPad
        armSetTextfield.keyboardType = .numberPad
    }
    
    @IBAction func tapRegisterBtn(_ sender: UIButton) {
        if let kindField = armKindTextfield.text, !kindField.isEmpty,
           let WeightTextfield = armWeightTextfield.text, !WeightTextfield.isEmpty, let weightField = Double(WeightTextfield),
           let CountTextfield = armCountTextfield.text, !CountTextfield.isEmpty, let countField = Int(CountTextfield),
           let SetTextfield = armSetTextfield.text, !SetTextfield.isEmpty, let setField = Int(SetTextfield) {
            
            armDelegate?.sendArmData(proArmKind: kindField, proArmWeight: weightField, proArmCount: countField, proArmSet: setField)
            
            let data01 = optionList(kind: kindField, weight: weightField, count: countField, set: setField)
            let data02 = weightField * Double(countField) * Double(setField)
            
            let armData01 = data01Array.map{
                [
                    "kind":$0.kind ,
                    "weight":$0.weight ,
                    "count":$0.count ,
                    "set":$0.set
                ]
            }
            let armData02 = data02
            
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(armData01, forKey: "armData01")
            userDefaults.setValue(armData02, forKey: "armData02")
            
            self.navigationController?.popViewController(animated: true)
            print("addArmVC 에서 등록버튼이 눌렸다.")
            
        } else {
            return
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
