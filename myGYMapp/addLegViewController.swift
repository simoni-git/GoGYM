//
//  addLegViewController.swift
//  myGYMapp
//
//  Created by MAC on 11/3/23.
//

import UIKit

protocol legProtocol {
    func sendLegData(proLegKind: String , proLegWeight: Double , proLegCount: Int , proLegSet: Int) //델🧪
}
class addLegViewController: UIViewController {
    
    var data01Array = [optionList]()
    var data02Array = [Double]()
    
    var legDelegate: legProtocol?
    
    @IBOutlet var legKindTextfield: UITextField!
    @IBOutlet var legWeightTextfield: UITextField!
    @IBOutlet var legCountTextfield: UITextField!
    @IBOutlet var legSetTextfield: UITextField!
    
    @IBOutlet var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.legKindTextfield.placeholder = "EX : 스쿼트"
        self.legWeightTextfield.placeholder = "EX: 30"
        self.legCountTextfield.placeholder = "EX: 10"
        self.legSetTextfield.placeholder = "EX: 5"
        
        self.registerBtn.layer.cornerRadius = 30
        legKindTextfield.keyboardType = .default
        legWeightTextfield.keyboardType = .decimalPad
        legCountTextfield.keyboardType = .numberPad
        legSetTextfield.keyboardType = .numberPad
    }
    
    @IBAction func tapRegisterBtn(_ sender: UIButton) {
        if let kindField = legKindTextfield.text, !kindField.isEmpty,
           let WeightTextfield = legWeightTextfield.text, !WeightTextfield.isEmpty, let weightField = Double(WeightTextfield),
           let CountTextfield = legCountTextfield.text, !CountTextfield.isEmpty, let countField = Int(CountTextfield),
           let SetTextfield = legSetTextfield.text, !SetTextfield.isEmpty, let setField = Int(SetTextfield) {
            
            legDelegate?.sendLegData(proLegKind: kindField, proLegWeight: weightField, proLegCount: countField, proLegSet: setField)
            
            let data01 = optionList(kind: kindField, weight: weightField, count: countField, set: setField)
            let data02 = weightField * Double(countField) * Double(setField)
            
            let legData01 = data01Array.map{
                [
                    "kind":$0.kind ,
                    "weight":$0.weight ,
                    "count":$0.count ,
                    "set":$0.set
                ]
            }
            let legData02 = data02
            
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(legData01, forKey: "legData01")
            userDefaults.setValue(legData02, forKey: "legData02")
            
            self.navigationController?.popViewController(animated: true)
            print("addLegVC 에서 등록버튼이 눌렸다.")
            
        } else {
            return
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
