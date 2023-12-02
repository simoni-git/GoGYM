//
//  ChestViewModel.swift
//  myGYMapp
//
//  Created by MAC on 12/1/23.
//

import Foundation
import UIKit

class AddChestViewModel {
    
    var data01Array = [optionList]()
    var data02Array = [Double]()
    var optionlist: optionList!
    
    func saveChestData(kind: String, weight: Double, count: Int, set: Int ) {
        
        let data01 = optionList(kind: kind, weight: weight, count: count, set: set)
        let data02 = weight * Double(count) * Double(set)
        
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
        
    }
}
        
        
        
 
