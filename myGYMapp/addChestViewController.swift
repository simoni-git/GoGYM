//
//  addChestViewController.swift
//  myGYMapp
//
//  Created by MAC on 11/1/23.
//



// 원래 chestViewController 에서 알럿이 하던 일을 여기 등록버튼에서 하면됨. 텍스트필드안에 값들을 저장하는메서드를 구현해주면된다는거임. 그걸 저장하면 다시 chestViewController로 가게 되고, 데이터도 끌고가면서 테이블뷰도 그에맞게 업데이트될수있게끔 구현할것.
import UIKit

protocol chestProtocl {
    func sendChestData(proChestKind: String , proChestWeight: Double , proChestCount: Int , proChestSet: Int) //델🧪
}
class addChestViewController: UIViewController {
    
    var data01Array = [optionList]()
    var data02Array = [Double]()
    
    var chestDelegate: chestProtocl?
    
    @IBOutlet var chestKindTextfield: UITextField!
    @IBOutlet var chestWeightTextfield: UITextField!
    @IBOutlet var chestCountTextfield: UITextField!
    @IBOutlet var chestSetTextfield: UITextField!
    
    @IBOutlet var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            let data01 = optionList(kind: kindField, weight: weightField, count: countField, set: setField)
            let data02 = weightField * Double(countField) * Double(setField)
            
            let chestData01 = data01Array.map{
                [
                    "kind":$0.kind ,
                    "weight":$0.weight ,
                    "count":$0.count ,
                    "set":$0.set
                ]
            }
            let chestData02 = data02
            
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(chestData01, forKey: "chestData01")
            userDefaults.setValue(chestData02, forKey: "chestData02")
            
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
