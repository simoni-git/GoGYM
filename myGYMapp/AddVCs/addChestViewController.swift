//
//  addChestViewController.swift
//  myGYMapp
//
//  Created by MAC on 11/1/23.
//

import UIKit

protocol chestProtocl {
    func sendChestData(proChestKind: String , proChestWeight: Double , proChestCount: Int , proChestSet: Int) //델🧪
}
class addChestViewController: UIViewController {
    
    var chestDelegate: chestProtocl?
    var viewmodel: AddChestViewModel!
    
    @IBOutlet var chestKindTextfield: UITextField!
    @IBOutlet var chestWeightTextfield: UITextField!
    @IBOutlet var chestCountTextfield: UITextField!
    @IBOutlet var chestSetTextfield: UITextField!
    
    @IBOutlet var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewmodel = AddChestViewModel()
        
        self.chestKindTextfield.placeholder = "EX : 벤치프레스"
        self.chestWeightTextfield.placeholder = "EX: 30"
        self.chestCountTextfield.placeholder = "EX: 10"
        self.chestSetTextfield.placeholder = "EX: 5"
        
        self.registerBtn.layer.cornerRadius = 30
        chestKindTextfield.keyboardType = .default
        chestWeightTextfield.keyboardType = .decimalPad
        chestCountTextfield.keyboardType = .numberPad
        chestSetTextfield.keyboardType = .numberPad
    }
    
    @IBAction func tapRegisterBtn(_ sender: UIButton) {
        
        if let kindField = chestKindTextfield.text, !kindField.isEmpty,
           let WeightTextfield = chestWeightTextfield.text, !WeightTextfield.isEmpty, let weightField = Double(WeightTextfield), 
           let CountTextfield = chestCountTextfield.text, !CountTextfield.isEmpty, let countField = Int(CountTextfield),
           let SetTextfield = chestSetTextfield.text, !SetTextfield.isEmpty, let setField = Int(SetTextfield) {
            
            chestDelegate?.sendChestData(proChestKind: kindField, proChestWeight: weightField, proChestCount: countField, proChestSet: setField)
            
            viewmodel.saveChestData(kind: kindField, weight: weightField, count: countField, set: setField)
            
                self.navigationController?.popViewController(animated: true)
                print("addChestVC 에서 등록버튼이 눌렸다.")
            
        } else {
            return
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
