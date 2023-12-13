//
//  LegViewModel.swift
//  myGYMapp
//
//  Created by 시모니 on 12/8/23.
//

import Foundation

class LegViewModel {
    
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
    
    var legArray = [optionList]() {
        didSet {
            saveDataOfLegArray()
            print("legArray 에 대한 didset 이 호출됨 , legArray 배열의 갯수는 --> \(legArray.count) 개")
        }
    }
    
    var legTotalVolume = [Double]() {
        didSet {
            saveDataOfLegTotalVolume()
            print("legTotalVolume 에 대한 didset 이 호출됨 , legTotalVolume 배열의 갯수는 --> \(legTotalVolume.count)개")
        }
    }
    
    func saveDataOfLegArray() {
        let legData01 = self.legArray.map{
            [
                "kind":$0.kind ,
                "weight": $0.weight ,
                "count": $0.count ,
                "set": $0.set
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(legData01, forKey: "legData01")
        print("legData01 이 userdefault 저장소에 저장되었다.")
    }
    
    func saveDataOfLegTotalVolume() {
        let legData02 = self.legTotalVolume
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(legData02, forKey: "legData02")
        print("legData02 이 userdefault 저장소에 저장되었다.")
    }
    
    func loadDataOfLegArray() {
        let userDefaults = UserDefaults.standard
        guard let legData01 = userDefaults.object(forKey: "legData01") as? [[String:Any]] else {return}
        self.legArray = legData01.compactMap{
            guard let kind = $0["kind"] as? String else {return nil}
            guard let weight = $0["weight"] as? Double else {return nil}
            guard let count = $0["count"] as? Int else {return nil}
            guard let set = $0["set"] as? Int else {return nil}
            
            return optionList(kind: kind, weight: weight, count: count, set: set)
        }
    }
    
    func loadDataOfLegTotalVolume() {
        let userDefaults = UserDefaults.standard
        if let legData02 = userDefaults.array(forKey: "legData02") as? [Double] {
            self.legTotalVolume = legData02
        }
    }
    
    func appendData() {
        let data = optionList(kind: kind, weight: weight, count: count, set: set)
        let total = weight * Double(count) * Double(set)
        
        self.legArray.append(data)
        self.legTotalVolume.append(total)
    }
    
}
