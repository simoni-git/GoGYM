//
//  addBackViewController.swift
//  myGYMapp
//
//  Created by MAC on 11/2/23.
//

import UIKit
import Combine

class addBackViewController: UIViewController {
    
    var data01Array = [optionList]()
    var data02Array = [Double]()
    
    var bag = Set<AnyCancellable>() //🧪
    var backVC: backViewController! //🧪
    
    @IBOutlet var backKindTextfield: UITextField!
    @IBOutlet var backWeightTextfield: UITextField!
    @IBOutlet var backCountTextfield: UITextField!
    @IBOutlet var backSetTextfield: UITextField!
    
    @IBOutlet var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        if let BackMainVC = navigationController?.viewControllers.first(where: {$0 is backViewController}) as? backViewController {
            backVC = BackMainVC
            
            backKindTextfield
                .myKindPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.kind, on: backVC)
                .store(in: &bag)
            
            backWeightTextfield
                .myWeightPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.weight, on: backVC)
                .store(in: &bag)
            
            backCountTextfield
                .myCountPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.count, on: backVC)
                .store(in: &bag)
            
            backSetTextfield
                .mySetPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.set, on: backVC)
                .store(in: &bag)
            
                
        }
        
    }
    
    @IBAction func tapRegisterBtn(_ sender: UIButton) {
        if let kindField = backKindTextfield.text, !kindField.isEmpty,
           let WeightTextfield = backWeightTextfield.text, !WeightTextfield.isEmpty, let weightField = Double(WeightTextfield),
           let CountTextfield = backCountTextfield.text, !CountTextfield.isEmpty, let countField = Int(CountTextfield),
           let SetTextfield = backSetTextfield.text, !SetTextfield.isEmpty, let setField = Int(SetTextfield) {
            
           //⬇️🧪
            let CombineChestKind = backVC.kind
            let CombineChestWeight = backVC.weight
            let CombineChestCount = backVC.count
            let CombineChestSet = backVC.set
            
            let CombineTotal = CombineChestWeight * Double(CombineChestCount) * Double(CombineChestSet)
            
            let CombineChestData = optionList(kind: CombineChestKind, weight: CombineChestWeight, count: CombineChestCount, set: CombineChestSet)
            
            
            backVC.backArray.append(CombineChestData)
            backVC.backTotalVolume.append(CombineTotal)
            
            //⬇️ 여기는 userDefault 사용하는부분이니까 일단 터치 ㄴㄴ
            
            let data01 = optionList(kind: kindField, weight: weightField, count: countField, set: setField)
            let data02 = weightField * Double(countField) * Double(setField)
            
            let backData01 = data01Array.map{
                [
                    "kind":$0.kind ,
                    "weight":$0.weight ,
                    "count":$0.count ,
                    "set":$0.set
                ]
            }
            let backData02 = data02
            
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(backData01, forKey: "backData01")
            userDefaults.setValue(backData02, forKey: "backData02")
            
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
        bag.forEach {$0.cancel()}
        print("addchestvc 메모리에서 해제되면서 deinit 발동")
    }
    
    
}

