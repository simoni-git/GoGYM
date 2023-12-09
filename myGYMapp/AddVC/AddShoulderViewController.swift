//
//  addShoulderViewController.swift
//  myGYMapp
//
//  Created by MAC on 11/3/23.
//

import UIKit
import Combine

class AddShoulderViewController: UIViewController {
    
    var viewmodel: AddShoulderViewModel!
    var shoulderVM: ShoulderViewModel!
    
    @IBOutlet var shoulderKindTextfield: UITextField!
    @IBOutlet var shoulderWeightTextfield: UITextField!
    @IBOutlet var shoulderCountTextfield: UITextField!
    @IBOutlet var shoulderSetTextfield: UITextField!
    
    @IBOutlet var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        viewmodel = AddShoulderViewModel()
        shoulderVM = ShoulderViewModel.shared
     
            shoulderKindTextfield
                .myKindPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.kind, on: shoulderVM)
                .store(in: &viewmodel.bag)
            
            shoulderWeightTextfield
                .myWeightPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.weight, on: shoulderVM)
                .store(in: &viewmodel.bag)
            
            shoulderCountTextfield
                .myCountPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.count, on: shoulderVM)
                .store(in: &viewmodel.bag)
            
            shoulderSetTextfield
                .mySetPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.set, on: shoulderVM)
                .store(in: &viewmodel.bag)
        
    }
    
    @IBAction func tapRegisterBtn(_ sender: UIButton) {
        if let kindField = shoulderKindTextfield.text, !kindField.isEmpty,
           let WeightTextfield = shoulderWeightTextfield.text, !WeightTextfield.isEmpty, let weightField = Double(WeightTextfield),
           let CountTextfield = shoulderCountTextfield.text, !CountTextfield.isEmpty, let countField = Int(CountTextfield),
           let SetTextfield = shoulderSetTextfield.text, !SetTextfield.isEmpty, let setField = Int(SetTextfield) {
            
            shoulderVM.appendData()
            viewmodel.saveUD(kind: kindField, weight: weightField, count: countField, set: setField)
            
            self.navigationController?.popViewController(animated: true)
            print("addShoulderVC 에서 등록버튼이 눌렸다.")
            
        } else {
            return
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
   private func configureView() {
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
    
    deinit {
        viewmodel.bag.forEach {$0.cancel()}
        print("addchestvc 메모리에서 해제되면서 deinit 발동")
    }
    
}
