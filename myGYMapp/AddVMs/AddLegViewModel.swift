//
//  AddLegViewModel.swift
//  myGYMapp
//
//  Created by MAC on 12/2/23.
//

import Foundation
import UIKit

class AddLegViewModel {
    
    var data01Array = [optionList]()
    var data02Array = [Double]()
    var optionlist: optionList!
    
    func saveBackData(kind: String, weight: Double, count: Int, set: Int ) {
        let data01 = optionList(kind: kind, weight: weight, count: count, set: set)
        let data02 = weight * Double(count) * Double(set)
        
        let legData01 = data01Array.map{
            [
                "kind":$0.kind ,
                "weight":$0.weight ,
                "count":$0.count ,
                "set":$0.set
            ]
        }
        let legData02 = data02
        
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(legData01, forKey: "legData01")
        userDefaults.setValue(legData02, forKey: "legData02")
    }
}
