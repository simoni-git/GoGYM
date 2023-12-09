//
//  AddShoulderViewModel.swift
//  myGYMapp
//
//  Created by 시모니 on 12/8/23.
//

import Foundation
import Combine

class AddShoulderViewModel {
    
    var data01Array = [optionList]()
    var data02Array = [Double]()
    var bag = Set<AnyCancellable>() //🧪
    
    func saveUD(kind: String , weight: Double , count: Int , set: Int) {
        
        let data01 = optionList(kind: kind, weight: weight, count: count, set: set)
        let data02 = weight * Double(count) * Double(set)
        
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
    }
    
}
