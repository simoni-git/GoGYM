//
//  addChestViewController.swift
//  myGYMapp
//
//  Created by MAC on 11/1/23.


import UIKit
import Combine

class addChestViewController: UIViewController {
    
    
    var data01Array = [optionList]()
    var data02Array = [Double]()
    
    var bag = Set<AnyCancellable>() //🧪
    var chestVC: chestViewController!//🧪
    
    
    @IBOutlet var chestKindTextfield: UITextField!
    @IBOutlet var chestWeightTextfield: UITextField!
    @IBOutlet var chestCountTextfield: UITextField!
    @IBOutlet var chestSetTextfield: UITextField!
    
    @IBOutlet var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       configureView()
        //⬇️🧪
        if let ChestMainVC = navigationController?.viewControllers.first(where: { $0 is chestViewController }) as? chestViewController {
            chestVC = ChestMainVC // 이조건이 바로 원래있던chestViewController 쓰겠다이거지, 새 인스턴스안만들고
         
            
            chestKindTextfield
                .myKindPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.kind, on: chestVC)
                .store(in: &bag)
            
            chestWeightTextfield
                .myWeightPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.weight, on: chestVC)
                .store(in: &bag)
            
            chestCountTextfield
                .myCountPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.count, on: chestVC)
                .store(in: &bag)
            
            chestSetTextfield
                .mySetPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.set, on: chestVC)
                .store(in: &bag)
        }
        
        
    }
    
    @IBAction func tapRegisterBtn(_ sender: UIButton) {
        
        if let kindField = chestKindTextfield.text, !kindField.isEmpty,
           let WeightTextfield = chestWeightTextfield.text, !WeightTextfield.isEmpty, let weightField = Double(WeightTextfield), 
           let CountTextfield = chestCountTextfield.text, !CountTextfield.isEmpty, let countField = Int(CountTextfield),
           let SetTextfield = chestSetTextfield.text, !SetTextfield.isEmpty, let setField = Int(SetTextfield) {
            
                
                //⬇️🧪
                let CombineChestKind = chestVC.kind
                let CombineChestWeight = chestVC.weight
                let CombineChestCount = chestVC.count
                let CombineChestSet = chestVC.set
                
                let CombineTotal = CombineChestWeight * Double(CombineChestCount) * Double(CombineChestSet)
                
                let CombineChestData = optionList(kind: CombineChestKind, weight: CombineChestWeight, count: CombineChestCount, set: CombineChestSet)
                
                
                chestVC.chestArray.append(CombineChestData)
                chestVC.chestTotalVolume.append(CombineTotal)
                
                //⬇️ 여기는 userDefault 사용하는부분이니까 일단 터치 ㄴㄴ
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
        bag.forEach {$0.cancel()}
        print("addchestvc 메모리에서 해제되면서 deinit 발동")
    }
    
}


