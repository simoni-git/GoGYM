//
//  finishViewController.swift
//  myGYMapp
//
//  Created by MAC on 10/24/23.
//

import UIKit
import CoreData

class finishViewController: UIViewController {
    
    var viewmodel: FinishViewModel!
    
    @IBOutlet var chestTotalVolumeLabel: UILabel!
    @IBOutlet var backTotalVolumeLabel: UILabel!
    @IBOutlet var legTotalVolumeLabel: UILabel!
    @IBOutlet var shoulderTotalVolumeLabel: UILabel!
    @IBOutlet var armTotalVolumeLabel: UILabel!
    
    @IBOutlet var todayTotalLabel: UILabel!
    @IBOutlet var doneBtn: UIButton!
   
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var saveBtn: UIButton!
    
    var chestTotalvolume: Double? = 0.0
    var backTotalVolume: Double? = 0.0
    var legTotalVolume: Double? = 0.0
    var shoulderTotalVolume: Double? = 0.0
    var armTotalVolume: Double? = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewmodel = FinishViewModel()
    
        updateUI()
        self.doneBtn.layer.cornerRadius = 5
        self.saveBtn.layer.cornerRadius = 15
        setupDatePicker()
        
    }
    
    func updateUI() {
        if let chestTotalvolume = self.chestTotalvolume ,
           let backTotalVolume = self.backTotalVolume ,
           let legTotalVolume = self.legTotalVolume ,
           let shoulderTotalVolume = self.shoulderTotalVolume ,
           let armTotalVolume = self.armTotalVolume {
            chestTotalVolumeLabel.text = ("--> \(chestTotalvolume) KG")
            backTotalVolumeLabel.text = ("--> \(backTotalVolume) KG")
            legTotalVolumeLabel.text = ("--> \(legTotalVolume) KG")
            shoulderTotalVolumeLabel.text = ("--> \(shoulderTotalVolume) KG")
            armTotalVolumeLabel.text = ("--> \(armTotalVolume) KG")
            
            self.todayTotalLabel.text = "오늘하루 총 볼륨 : \(chestTotalvolume + backTotalVolume + legTotalVolume + shoulderTotalVolume + armTotalVolume)KG"
        }
    }
    
    private func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        dateTextField.inputView = datePicker
        dateTextField.placeholder = "터치해서 날짜를 선택해주세요"
    }
    
    @objc func dateChange(_ sender: UIDatePicker) {
        self.dateTextField.text = dateFormat(date: sender.date)
        self.doneBtn.isEnabled = true
        
    }
    
    private func dateFormat(date: Date) -> String {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy년 MM월 dd일"
        return formater.string(from: date)
    }
    
    @IBAction func tapSaveBtn(_ sender: UIButton) {
        savedata()
        
        self.saveBtn.isHidden = true
        
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
            print("저장하기버튼이 눌리면서 앱 데이터가 모두 삭제되었습니다.")
            
            guard let mainVC = navigationController?.viewControllers.first(where: { $0 is mainViewController
            }) else {return}
            
            navigationController?.popToViewController(mainVC, animated: true)
        }
    }
    
    func savedata() {
        
        guard let todaytotal = self.todayTotalLabel.text else {return}
        guard let  date = dateTextField.text else {return}
        viewmodel.appendSaveList(todaytotal: todaytotal, date: date)
        saveInTheCoredata()
        
    }
    
    
    @IBAction func tapDoneBtn(_ sender: UIButton) {
        
        dateTextField.resignFirstResponder()
        self.doneBtn.isEnabled = false
        self.saveBtn.isHidden = false
        
    }

    func saveInTheCoredata() {
        guard let date = dateTextField.text else {return}
        guard let totalVolume = todayTotalLabel.text else {return}
        viewmodel.saveCoreData(date: date, totalVolume: totalVolume)
    }
}


