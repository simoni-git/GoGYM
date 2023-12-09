//
//  ArmViewModel.swift
//  myGYMapp
//
//  Created by 시모니 on 12/8/23.
//

import Foundation

class ArmViewModel {
    
    static let shared = ArmViewModel()
    private init() {}
    
    var kind: String = "" {
        didSet {
            print("kind 에 값들어옴 --> \(kind)")
        }
    }
    var weight: Double = 0.0 {
        didSet {
            print("weight 에 값들어옴 --> \(weight)")
        }
    }
    var count: Int = 0 {
        didSet {
            print("count 에 값들어옴 --> \(count)")
        }
    }
    var set: Int = 0 {
        didSet {
            print("set 에 값들어옴 --> \(set)")
        }
    }
    
    
    var armArray = [optionList]() {
        didSet {
            saveDataOfArmArray()
            print("armArray 에 대한 didset 이 호출됨 , armArray 배열의 갯수는 --> \(armArray.count) 개")
        }
    }
    
    var armTotalVolume = [Double]() {
        didSet {
            saveDataOfArmTotalVolume()
            print("armTotalVolume 에 대한 didset 이 호출됨 , armTotalVolume 배열의 갯수는 --> \(armTotalVolume.count)개")
        }
    }
    
    func saveDataOfArmArray() {
        let armData01 = self.armArray.map{
            [
                "kind":$0.kind ,
                "weight": $0.weight ,
                "count": $0.count ,
                "set": $0.set
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(armData01, forKey: "armData01")
        print("armData01 이 userdefault 저장소에 저장되었다.")
    }
    
    func saveDataOfArmTotalVolume() {
        let armData02 = self.armTotalVolume
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(armData02, forKey: "armData02")
        print("armData02 이 userdefault 저장소에 저장되었다.")
    }
    
    func loadDataOfArmArray() {
        let userDefaults = UserDefaults.standard
        guard let armData01 = userDefaults.object(forKey: "armData01") as? [[String:Any]] else {return}
        self.armArray = armData01.compactMap{
            guard let kind = $0["kind"] as? String else {return nil}
            guard let weight = $0["weight"] as? Double else {return nil}
            guard let count = $0["count"] as? Int else {return nil}
            guard let set = $0["set"] as? Int else {return nil}
            
            return optionList(kind: kind, weight: weight, count: count, set: set)
        }
    }
    
    func loadDataOfArmTotalVolume() {
        let userDefaults = UserDefaults.standard
        if let armData02 = userDefaults.array(forKey: "armData02") as? [Double] {
            self.armTotalVolume = armData02
        }
    }
    
    func appendData() {
        let data = optionList(kind: kind, weight: weight, count: count, set: set)
        let total = weight * Double(count) * Double(set)
        
        self.armArray.append(data)
        self.armTotalVolume.append(total)
    }
    
}
