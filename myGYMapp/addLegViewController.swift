//
//  addLegViewController.swift
//  myGYMapp
//
//  Created by MAC on 11/3/23.
//

import UIKit
import Combine


class addLegViewController: UIViewController {
    
    var data01Array = [optionList]()
    var data02Array = [Double]()
    
    var bag = Set<AnyCancellable>() //🧪
    var legVC: legViewController! //🧪
  
    
    @IBOutlet var legKindTextfield: UITextField!
    @IBOutlet var legWeightTextfield: UITextField!
    @IBOutlet var legCountTextfield: UITextField!
    @IBOutlet var legSetTextfield: UITextField!
    
    @IBOutlet var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        if let LegMainVC = navigationController?.viewControllers.first(where: {$0 is legViewController}) as? legViewController {
            legVC = LegMainVC
            
            legKindTextfield
                .myKindPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.kind, on: legVC)
                .store(in: &bag)
            
            legWeightTextfield
                .myWeightPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.weight, on: legVC)
                .store(in: &bag)
            
            legCountTextfield
                .myCountPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.count, on: legVC)
                .store(in: &bag)
            
            legSetTextfield
                .mySetPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.set, on: legVC)
                .store(in: &bag)
                
        }
     
    }
    
    @IBAction func tapRegisterBtn(_ sender: UIButton) {
        if let kindField = legKindTextfield.text, !kindField.isEmpty,
           let WeightTextfield = legWeightTextfield.text, !WeightTextfield.isEmpty, let weightField = Double(WeightTextfield),
           let CountTextfield = legCountTextfield.text, !CountTextfield.isEmpty, let countField = Int(CountTextfield),
           let SetTextfield = legSetTextfield.text, !SetTextfield.isEmpty, let setField = Int(SetTextfield) {
            
            //⬇️🧪
             let CombineChestKind = legVC.kind
             let CombineChestWeight = legVC.weight
             let CombineChestCount = legVC.count
             let CombineChestSet = legVC.set
             
             let CombineTotal = CombineChestWeight * Double(CombineChestCount) * Double(CombineChestSet)
             
             let CombineChestData = optionList(kind: CombineChestKind, weight: CombineChestWeight, count: CombineChestCount, set: CombineChestSet)
             
             
            legVC.legArray.append(CombineChestData)
            legVC.legTotalVolume.append(CombineTotal)
             
             //⬇️ 여기는 userDefault 사용하는부분이니까 일단 터치 ㄴㄴ
            
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
        bag.forEach {$0.cancel()}
        print("addchestvc 메모리에서 해제되면서 deinit 발동")
    }
    
}
