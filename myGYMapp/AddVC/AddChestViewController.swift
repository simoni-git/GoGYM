//
//  addChestViewController.swift
//  myGYMapp
//
//  Created by MAC on 11/1/23.


import UIKit
import Combine

class AddChestViewController: UIViewController {
    
    var viewmodel: AddChestViewModel!
    var chestVM: ChestViewModel!
    
    @IBOutlet var chestKindTextfield: UITextField!
    @IBOutlet var chestWeightTextfield: UITextField!
    @IBOutlet var chestCountTextfield: UITextField!
    @IBOutlet var chestSetTextfield: UITextField!
    
    @IBOutlet var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        viewmodel = AddChestViewModel()
        //⬇️ 싱글톤패턴으로 하니까 저장됨!!!
        

            chestKindTextfield
                .myKindPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.kind, on: chestVM)
                .store(in: &viewmodel.bag)
            
            chestWeightTextfield
                .myWeightPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.weight, on: chestVM)
                .store(in: &viewmodel.bag)
            
            chestCountTextfield
                .myCountPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.count, on: chestVM)
                .store(in: &viewmodel.bag)
            
            chestSetTextfield
                .mySetPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.set, on: chestVM)
                .store(in: &viewmodel.bag)
        
    }
    
    @IBAction func tapRegisterBtn(_ sender: UIButton) {
        
        if let kindField = chestKindTextfield.text, !kindField.isEmpty,
           let WeightTextfield = chestWeightTextfield.text, !WeightTextfield.isEmpty, let weightField = Double(WeightTextfield), 
           let CountTextfield = chestCountTextfield.text, !CountTextfield.isEmpty, let countField = Int(CountTextfield),
           let SetTextfield = chestSetTextfield.text, !SetTextfield.isEmpty, let setField = Int(SetTextfield) {
              
            chestVM.appendData()
            viewmodel.saveUD(kind: kindField, weight: weightField, count: countField, set: setField)
                
                self.navigationController?.popViewController(animated: true)
                print("addChestVC 에서 등록버튼이 눌렸다.")
                
            } else {
                return
            }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
   private func configureView() {
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
    
    deinit {
        viewmodel.bag.forEach {$0.cancel()}
        print("addchestvc 메모리에서 해제되면서 deinit 발동")
    }
    
}


