//
//  addBackViewController.swift
//  myGYMapp
//
//  Created by MAC on 11/2/23.
//

import UIKit
import Combine

class AddBackViewController: UIViewController {
    
    var viewmodel: AddBackViewModel!
    var backVM: BackViewModel!
    
    @IBOutlet var backKindTextfield: UITextField!
    @IBOutlet var backWeightTextfield: UITextField!
    @IBOutlet var backCountTextfield: UITextField!
    @IBOutlet var backSetTextfield: UITextField!
    
    @IBOutlet var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        viewmodel = AddBackViewModel()
        backVM = BackViewModel.shared
        
            backKindTextfield
                .myKindPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.kind, on: backVM)
                .store(in: &viewmodel.bag)
            
            backWeightTextfield
                .myWeightPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.weight, on: backVM)
                .store(in: &viewmodel.bag)
            
            backCountTextfield
                .myCountPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.count, on: backVM)
                .store(in: &viewmodel.bag)
            
            backSetTextfield
                .mySetPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.set, on: backVM)
                .store(in: &viewmodel.bag)
        
    }
    
    @IBAction func tapRegisterBtn(_ sender: UIButton) {
        if let kindField = backKindTextfield.text, !kindField.isEmpty,
           let WeightTextfield = backWeightTextfield.text, !WeightTextfield.isEmpty, let weightField = Double(WeightTextfield),
           let CountTextfield = backCountTextfield.text, !CountTextfield.isEmpty, let countField = Int(CountTextfield),
           let SetTextfield = backSetTextfield.text, !SetTextfield.isEmpty, let setField = Int(SetTextfield) {
            
            backVM.appendData()
            viewmodel.saveUD(kind: kindField, weight: weightField, count: countField, set: setField)
            
            self.navigationController?.popViewController(animated: true)
            print("addBackVC 에서 등록버튼이 눌렸다.")
            
        } else {
            return
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func configureView() {
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
    
    deinit {
        viewmodel.bag.forEach {$0.cancel()}
        print("addchestvc 메모리에서 해제되면서 deinit 발동")
    }
    
}

