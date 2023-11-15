//
//  gymKindViewController.swift
//  myGYMapp
//
//  Created by MAC on 10/24/23.
//

import UIKit

class gymKindViewController: UIViewController {
    
    var chestvolumevalue: Double? = 0.0
    var backvolumevalue: Double? = 0.0
    var legvolumevalue: Double? = 0.0
    var shouldervolumevalue: Double? = 0.0
    var armvolumevalue: Double? = 0.0
    
    @IBOutlet var chestBtn: UIButton!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var legBtn: UIButton!
    @IBOutlet var shoulderBtn: UIButton!
    @IBOutlet var armBtn: UIButton!
    
    @IBOutlet var finishGym: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        chestBtn.layer.cornerRadius = 15
        backBtn.layer.cornerRadius = 15
        legBtn.layer.cornerRadius = 15
        shoulderBtn.layer.cornerRadius = 15
        armBtn.layer.cornerRadius = 15
        finishGym.layer.cornerRadius = 15
        
        NotificationCenter.default.addObserver(self, selector: #selector(chestVolumeValue), name: .chestFinalTotalVolume, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(backVolumeValue), name: .backFinalTotalVolume, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(legVolumeValue), name: .legFinalTotalVolume, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(shoulderVolumeValue), name: .shoulderFinalTotalVolume, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(armVolumeValue), name: .armFinalTotalVolume, object: nil)
    }
    
    
    @IBAction func tapQuestionMark(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "도움말",
                                      message: "1. 기록할 부위를 누르고 상세정보를 기입하세요. 2.모든 운동기록이 끝났으면 Finish 버튼을 클릭하세요 ", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "확인했습니다", style: .default)
        alert.addAction(okBtn)
        present(alert, animated: true)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        saveData()
    }
    
    @IBAction func tapFinishBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "운동을 완료하시겠습니까?", message: nil, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "네", style: .default) { [weak self] _ in
            
            guard let finishVC = self?.storyboard?.instantiateViewController(identifier: "finishViewController") as? finishViewController else {return}
            finishVC.chestTotalvolume = self?.chestvolumevalue
            finishVC.backTotalVolume = self?.backvolumevalue
            finishVC.legTotalVolume = self?.legvolumevalue
            finishVC.shoulderTotalVolume = self?.shouldervolumevalue
            finishVC.armTotalVolume = self?.armvolumevalue
            
            self?.navigationController?.pushViewController(finishVC, animated: true)
        }
        let cancelBtn = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
        
        alert.addAction(okBtn)
        alert.addAction(cancelBtn)
        present(alert, animated: true)
    }
}

