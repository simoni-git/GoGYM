//
//  ShoulderViewModel.swift
//  myGYMapp
//
//  Created by 시모니 on 12/8/23.
//

import Foundation

class ShoulderViewModel {
    
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
    
    var shoulderArray = [optionList]() {
        didSet {
            saveDataOfShoulderArray()
            print("shoulderArray 에 대한 didset 이 호출됨 , shoulderArray 배열의 갯수는 --> \(shoulderArray.count) 개")
        }
    }
    
    var shoulderTotalVolume = [Double]() {
        didSet {
            saveDataOfShoulderTotalVolume()
            print("shoulderTotalVolume 에 대한 didset 이 호출됨 , shoulderTotalVolume 배열의 갯수는 --> \(shoulderTotalVolume.count)개")
        }
    }
    
    func saveDataOfShoulderArray() {
        let shoulderData01 = self.shoulderArray.map{
            [
                "kind":$0.kind ,
                "weight": $0.weight ,
                "count": $0.count ,
                "set": $0.set
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(shoulderData01, forKey: "shoulderData01")
        print("shoulderData01 이 userdefault 저장소에 저장되었다.")
    }
    
    func saveDataOfShoulderTotalVolume() {
        let shoulderData02 = self.shoulderTotalVolume
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(shoulderData02, forKey: "shoulderData02")
        print("shoulderData02 이 userdefault 저장소에 저장되었다.")
    }
    
    func loadDataOfShoulderArray() {
        let userDefaults = UserDefaults.standard
        guard let shoulderData01 = userDefaults.object(forKey: "shoulderData01") as? [[String:Any]] else {return}
        self.shoulderArray = shoulderData01.compactMap{
            guard let kind = $0["kind"] as? String else {return nil}
            guard let weight = $0["weight"] as? Double else {return nil}
            guard let count = $0["count"] as? Int else {return nil}
            guard let set = $0["set"] as? Int else {return nil}
            
            return optionList(kind: kind, weight: weight, count: count, set: set)
        }
    }
    
    func loadDataOfShoulderTotalVolume() {
        let userDefaults = UserDefaults.standard
        if let shoulderData02 = userDefaults.array(forKey: "shoulderData02") as? [Double] {
            self.shoulderTotalVolume = shoulderData02
        }
    }
    
    func appendData() {
        let data = optionList(kind: kind, weight: weight, count: count, set: set)
        let total = weight * Double(count) * Double(set)
        
        self.shoulderArray.append(data)
        self.shoulderTotalVolume.append(total)
    }
    
}
