//
//  BackViewModel.swift
//  myGYMapp
//
//  Created by 시모니 on 12/8/23.
//

import Foundation

class BackViewModel {
    
    static let shared = BackViewModel()
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
    
    var backArray = [optionList]() {
        didSet {
            saveDataOfBackArray()
            print("backArray 에 대한 didset 이 호출됨 , backArray 배열의 갯수는 --> \(backArray.count) 개")
        }
    }
    
    var backTotalVolume = [Double]() {
        didSet {
            saveDataOfBackTotalVolume()
            print("backTotalVolume 에 대한 didset 이 호출됨 , backTotalVolume 배열의 갯수는 --> \(backTotalVolume.count)개")
        }
    }
    
    func saveDataOfBackArray() {
        let backData01 = self.backArray.map{
            [
                "kind":$0.kind ,
                "weight": $0.weight ,
                "count": $0.count ,
                "set": $0.set
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(backData01, forKey: "backData01")
        print("backData01 이 userdefault 저장소에 저장되었다.")
    }
    
    func saveDataOfBackTotalVolume() {
        let backData02 = self.backTotalVolume
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(backData02, forKey: "backData02")
        print("backData02 이 userdefault 저장소에 저장되었다.")
    }
    
    func loadDataOfbackArray() {
        let userDefaults = UserDefaults.standard
        guard let backData01 = userDefaults.object(forKey: "backData01") as? [[String:Any]] else {return}
        self.backArray = backData01.compactMap{
            guard let kind = $0["kind"] as? String else {return nil}
            guard let weight = $0["weight"] as? Double else {return nil}
            guard let count = $0["count"] as? Int else {return nil}
            guard let set = $0["set"] as? Int else {return nil}
            
            return optionList(kind: kind, weight: weight, count: count, set: set)
        }
    }
    
    func loadDataOfbackTotalVolume() {
        let userDefaults = UserDefaults.standard
        if let backData02 = userDefaults.array(forKey: "backData02") as? [Double] {
            self.backTotalVolume = backData02
        }
    }
    
    func appendData() {
        let data = optionList(kind: kind, weight: weight, count: count, set: set)
        let total = weight * Double(count) * Double(set)
        
        self.backArray.append(data)
        self.backTotalVolume.append(total)
    }
    
}
