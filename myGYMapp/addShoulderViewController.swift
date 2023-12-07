//
//  addShoulderViewController.swift
//  myGYMapp
//
//  Created by MAC on 11/3/23.
//

import UIKit
import Combine

class addShoulderViewController: UIViewController {
    
    var data01Array = [optionList]()
    var data02Array = [Double]()
    
    var bag = Set<AnyCancellable>() //🧪
    var shoulderVC: shoulderViewController! //🧪
   
    
    @IBOutlet var shoulderKindTextfield: UITextField!
    @IBOutlet var shoulderWeightTextfield: UITextField!
    @IBOutlet var shoulderCountTextfield: UITextField!
    @IBOutlet var shoulderSetTextfield: UITextField!
    
    @IBOutlet var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        if let ShoulderMainVC = navigationController?.viewControllers.first(where: {$0 is shoulderViewController}) as? shoulderViewController {
            shoulderVC = ShoulderMainVC
            
            shoulderKindTextfield
                .myKindPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.kind, on: shoulderVC)
                .store(in: &bag)
            
            shoulderWeightTextfield
                .myWeightPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.weight, on: shoulderVC)
                .store(in: &bag)
            
            shoulderCountTextfield
                .myCountPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.count, on: shoulderVC)
                .store(in: &bag)
            
            shoulderSetTextfield
                .mySetPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.set, on: shoulderVC)
                .store(in: &bag)
        }
        
       
    }
    
    @IBAction func tapRegisterBtn(_ sender: UIButton) {
        if let kindField = shoulderKindTextfield.text, !kindField.isEmpty,
           let WeightTextfield = shoulderWeightTextfield.text, !WeightTextfield.isEmpty, let weightField = Double(WeightTextfield),
           let CountTextfield = shoulderCountTextfield.text, !CountTextfield.isEmpty, let countField = Int(CountTextfield),
           let SetTextfield = shoulderSetTextfield.text, !SetTextfield.isEmpty, let setField = Int(SetTextfield) {
            
            //⬇️🧪
             let CombineChestKind = shoulderVC.kind
             let CombineChestWeight = shoulderVC.weight
             let CombineChestCount = shoulderVC.count
             let CombineChestSet = shoulderVC.set
             
             let CombineTotal = CombineChestWeight * Double(CombineChestCount) * Double(CombineChestSet)
             
             let CombineChestData = optionList(kind: CombineChestKind, weight: CombineChestWeight, count: CombineChestCount, set: CombineChestSet)
             
             
            shoulderVC.shoulderArray.append(CombineChestData)
            shoulderVC.shoulderTotalVolume.append(CombineTotal)
             
             //⬇️ 여기는 userDefault 사용하는부분이니까 일단 터치 ㄴㄴ
          
            let data01 = optionList(kind: kindField, weight: weightField, count: countField, set: setField)
            let data02 = weightField * Double(countField) * Double(setField)
            
            let shoulderData01 = data01Array.map{
                [
                    "kind":$0.kind ,
                    "weight":$0.weight ,
                    "count":$0.count ,
                    "set":$0.set
                ]
            }
            let shoulderData02 = data02
            
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(shoulderData01, forKey: "shoulderData01")
            userDefaults.setValue(shoulderData02, forKey: "shoulderData02")
            
            self.navigationController?.popViewController(animated: true)
            print("addShoulderVC 에서 등록버튼이 눌렸다.")
            
        } else {
            return
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func configureView() {
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
        bag.forEach {$0.cancel()}
        print("addchestvc 메모리에서 해제되면서 deinit 발동")
    }
    
}
