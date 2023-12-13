//
//  addLegViewController.swift
//  myGYMapp
//
//  Created by MAC on 11/3/23.
//

import UIKit
import Combine

class AddLegViewController: UIViewController {
  
    var viewmodel: AddLegViewModel!
    var legVM: LegViewModel!
    
    @IBOutlet var legKindTextfield: UITextField!
    @IBOutlet var legWeightTextfield: UITextField!
    @IBOutlet var legCountTextfield: UITextField!
    @IBOutlet var legSetTextfield: UITextField!
    
    @IBOutlet var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        viewmodel = AddLegViewModel()
            
            legKindTextfield
                .myKindPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.kind, on: legVM)
                .store(in: &viewmodel.bag)
            
            legWeightTextfield
                .myWeightPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.weight, on: legVM)
                .store(in: &viewmodel.bag)
            
            legCountTextfield
                .myCountPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.count, on: legVM)
                .store(in: &viewmodel.bag)
            
            legSetTextfield
                .mySetPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.set, on: legVM)
                .store(in: &viewmodel.bag)
     
    }
    
    @IBAction func tapRegisterBtn(_ sender: UIButton) {
        if let kindField = legKindTextfield.text, !kindField.isEmpty,
           let WeightTextfield = legWeightTextfield.text, !WeightTextfield.isEmpty, let weightField = Double(WeightTextfield),
           let CountTextfield = legCountTextfield.text, !CountTextfield.isEmpty, let countField = Int(CountTextfield),
           let SetTextfield = legSetTextfield.text, !SetTextfield.isEmpty, let setField = Int(SetTextfield) {
            
            legVM.appendData()
            viewmodel.saveUD(kind: kindField, weight: weightField, count: countField, set: setField)
            
            self.navigationController?.popViewController(animated: true)
            print("addLegVC 에서 등록버튼이 눌렸다.")
            
        } else {
            return
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func configureView() {
        self.legKindTextfield.placeholder = "EX : 데드리프트"
        self.legWeightTextfield.placeholder = "EX: 30"
        self.legCountTextfield.placeholder = "EX: 10"
        self.legSetTextfield.placeholder = "EX: 5"
        
        self.registerBtn.layer.cornerRadius = 30
        legKindTextfield.keyboardType = .default
        legWeightTextfield.keyboardType = .decimalPad
        legCountTextfield.keyboardType = .numberPad
        legSetTextfield.keyboardType = .numberPad
    }
    
    deinit {
        viewmodel.bag.forEach {$0.cancel()}
        print("addchestvc 메모리에서 해제되면서 deinit 발동")
    }
    
}
