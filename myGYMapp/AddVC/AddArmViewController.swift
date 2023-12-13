//
//  addArmViewController.swift
//  myGYMapp
//
//  Created by MAC on 11/3/23.
//

import UIKit
import Combine

class AddArmViewController: UIViewController {
    
    var viewmodel: AddArmViewModel!
    var armVM: ArmViewModel!
   
    @IBOutlet var armKindTextfield: UITextField!
    @IBOutlet var armWeightTextfield: UITextField!
    @IBOutlet var armCountTextfield: UITextField!
    @IBOutlet var armSetTextfield: UITextField!
    
    @IBOutlet var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        viewmodel = AddArmViewModel()
    
            armKindTextfield
                .myKindPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.kind, on: armVM)
                .store(in: &viewmodel.bag)
            
            armWeightTextfield
                .myWeightPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.weight, on: armVM)
                .store(in: &viewmodel.bag)
            
            armCountTextfield
                .myCountPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.count, on: armVM)
                .store(in: &viewmodel.bag)
            
            armSetTextfield
                .mySetPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.set, on: armVM)
                .store(in: &viewmodel.bag)
        
    }
    
    @IBAction func tapRegisterBtn(_ sender: UIButton) {
        if let kindField = armKindTextfield.text, !kindField.isEmpty,
           let WeightTextfield = armWeightTextfield.text, !WeightTextfield.isEmpty, let weightField = Double(WeightTextfield),
           let CountTextfield = armCountTextfield.text, !CountTextfield.isEmpty, let countField = Int(CountTextfield),
           let SetTextfield = armSetTextfield.text, !SetTextfield.isEmpty, let setField = Int(SetTextfield) {
            
            armVM.appendData()
            viewmodel.saveUD(kind: kindField, weight: weightField, count: countField, set: setField)
            
            self.navigationController?.popViewController(animated: true)
            print("addArmVC 에서 등록버튼이 눌렸다.")
            
        } else {
            return
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
   private func configure() {
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
    
    deinit {
        viewmodel.bag.forEach {$0.cancel()}
        print("addchestvc 메모리에서 해제되면서 deinit 발동")
    }

}
