//
//  GymKindViewModel.swift
//  myGYMapp
//
//  Created by MAC on 12/2/23.
//

import UIKit

class GymKindViewModel {
    
    var chestvolumevalue: Double? = 0.0
    var backvolumevalue: Double? = 0.0
    var legvolumevalue: Double? = 0.0
    var shouldervolumevalue: Double? = 0.0
    var armvolumevalue: Double? = 0.0
    
    
    func observer() {
        NotificationCenter.default.addObserver(self, selector: #selector(chestVolumeValue), name: .chestFinalTotalVolume, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(backVolumeValue), name: .backFinalTotalVolume, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(legVolumeValue), name: .legFinalTotalVolume, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(shoulderVolumeValue), name: .shoulderFinalTotalVolume, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(armVolumeValue), name: .armFinalTotalVolume, object: nil)
    }
    
    @objc func chestVolumeValue(_ notification: Notification) {
        let data = notification.object as! Double
        self.chestvolumevalue = data
        print("chestViewcontroller 에서 viewWillDisapear 이 호출됬다 , 메인뷰컨트롤러에있는 chestvolumevalue의 값은 ? \(chestvolumevalue)")
    }
    
    @objc func backVolumeValue(_ notification: Notification) {
        let data = notification.object as! Double
        self.backvolumevalue = data
        print("backViewcontroller 에서 viewWillDisapear 이 호출됬다 , 메인뷰컨트롤러에있는 backvolumevalue의 값은 ? \(backvolumevalue)")
    }
    
    @objc func legVolumeValue(_ notification: Notification) {
        let data = notification.object as! Double
        self.legvolumevalue = data
        print("legViewcontroller 에서 viewWillDisapear 이 호출됬다 , 메인뷰컨트롤러에있는 legvolumevalue의 값은 ? \(legvolumevalue)")
    }
    
    @objc func shoulderVolumeValue(_ notification: Notification) {
        let data = notification.object as! Double
        self.shouldervolumevalue = data
        print("shoulderViewcontroller 에서 viewWillDisapear 이 호출됬다 , 메인뷰컨트롤러에있는 shouldervolumevalue의 값은 ? \(shouldervolumevalue)")
    }
    @objc func armVolumeValue(_ notification: Notification) {
        let data = notification.object as! Double
        self.armvolumevalue = data
        print("armViewcontroller 에서 viewWillDisapear 이 호출됬다 , 메인뷰컨트롤러에있는 armvolumevalue의 값은 ? \(armvolumevalue)")
    }
    
    func saveData() {
        let chestVolumeData = self.chestvolumevalue
        let backVolumeData = self.backvolumevalue
        let legVolumeData = self.legvolumevalue
        let shoulderVolumeData = self.shouldervolumevalue
        let armVolumeData = self.armvolumevalue
        
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(chestVolumeData, forKey: "chestVolumeData")
        userDefaults.setValue(backVolumeData, forKey: "backVolumeData")
        userDefaults.setValue(legVolumeData, forKey: "legVolumeData")
        userDefaults.setValue(shoulderVolumeData, forKey: "shoulderVolumeData")
        userDefaults.setValue(armVolumeData, forKey: "armVolumeData")
        
    }
    
    func loadData() {
        
        let userDefaults = UserDefaults.standard
        
        if let chestVolumeData = userDefaults.object(forKey: "chestVolumeData") as? Double {
            self.chestvolumevalue = chestVolumeData
        }
        if let backVolumeData = userDefaults.object(forKey: "backVolumeData") as? Double {
            self.backvolumevalue = backVolumeData
        }
        if let legVolumeData = userDefaults.object(forKey: "legVolumeData") as? Double {
            self.legvolumevalue = legVolumeData
        }
        if let shoulderVolumeData = userDefaults.object(forKey: "shoulderVolumeData") as? Double {
            self.shouldervolumevalue = shoulderVolumeData
        }
        if let armVolumeData = userDefaults.object(forKey: "armVolumeData") as? Double {
            self.armvolumevalue = armVolumeData
        }
    }
    
    
    
}
