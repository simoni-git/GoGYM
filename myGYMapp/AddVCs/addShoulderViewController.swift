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

    var shoulderDelegate: shoulderProtocol?
    var viewmodel: AddShoulderViewModel!
    
    @IBOutlet var shoulderKindTextfield: UITextField!
    @IBOutlet var shoulderWeightTextfield: UITextField!
    @IBOutlet var shoulderCountTextfield: UITextField!
    @IBOutlet var shoulderSetTextfield: UITextField!
    
    @IBOutlet var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewmodel = AddShoulderViewModel()
        
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
            viewmodel.saveBackData(kind: kindField, weight: weightField, count: countField, set: setField)
            
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
