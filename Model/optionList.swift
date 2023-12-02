//
//  chestList.swift
//  myGYMapp
//
//  Created by MAC on 10/24/23.
//

import Foundation

struct optionList {
    let kind: String
    let weight: Double
    let count: Int
    let set: Int
    
    init(kind: String, weight: Double, count: Int, set: Int) {
        self.kind = kind
        self.weight = weight
        self.count = count
        self.set = set
    }
}
