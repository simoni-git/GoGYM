//
//  ChestViewModel.swift
//  myGYMapp
//
//  Created by 시모니 on 12/8/23.
//

import Foundation
import Combine

class ChestViewModel {
    
    static let shared = ChestViewModel()
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
    
    
    var chestArray = [optionList]() {
        didSet {
            saveDataOfChestArray()
            print("chestArray 에 대한 didset 이 호출됨 , chestArray 배열의 갯수는 --> \(chestArray.count) 개")
        }
    }
    
    var chestTotalVolume = [Double]() {
        didSet {
            saveDataOfChestTotalVolume()
            print("chestTotalVolume 에 대한 didset 이 호출됨 , chestTotalVolume 배열의 갯수는 --> \(chestTotalVolume.count)개")
        }
    }
    
    func saveDataOfChestArray() {
        let chestData01 = self.chestArray.map{
            [
                "kind":$0.kind ,
                "weight": $0.weight ,
                "count": $0.count ,
                "set": $0.set
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(chestData01, forKey: "chestData01")
        print("chestData01 이 userdefault 저장소에 저장되었다.")
    }
    
    func saveDataOfChestTotalVolume() {
        let chestData02 = self.chestTotalVolume
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(chestData02, forKey: "chestData02")
        print("chestData02 이 userdefault 저장소에 저장되었다.")
    }
    
    func loadDataOfChestArray() {
        let userDefaults = UserDefaults.standard
        guard let chestData01 = userDefaults.object(forKey: "chestData01") as? [[String:Any]] else {return}
        self.chestArray = chestData01.compactMap{
            guard let kind = $0["kind"] as? String else {return nil}
            guard let weight = $0["weight"] as? Double else {return nil}
            guard let count = $0["count"] as? Int else {return nil}
            guard let set = $0["set"] as? Int else {return nil}
            
            return optionList(kind: kind, weight: weight, count: count, set: set)
        }
    }
    
    func loadDataOfChestTotalVolume() {
        let userDefaults = UserDefaults.standard
        if let chestData02 = userDefaults.array(forKey: "chestData02") as? [Double] {
            self.chestTotalVolume = chestData02
        }
    }
    
    func appendData() {
        let data = optionList(kind: kind, weight: weight, count: count, set: set)
        let total = weight * Double(count) * Double(set)
        
        self.chestArray.append(data)
        self.chestTotalVolume.append(total)
    }
    
}
