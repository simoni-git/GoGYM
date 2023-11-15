//
//  finishViewController.swift
//  myGYMapp
//
//  Created by MAC on 10/24/23.
//

import UIKit
import CoreData

class finishViewController: UIViewController {
    
    var context: NSManagedObjectContext {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        return app.persistentContainer.viewContext
    }
    
    var savelist = [saveList]()
    
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
        print("finishViewcontroller 에서 프린트한 savelist 의 갯수\(savelist.count)")
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
        let data = saveList(date: date, totalVolume: todaytotal)
        self.savelist.append(data)
        saveInTheCoredata()
    }
    
    
    @IBAction func tapDoneBtn(_ sender: UIButton) {
        dateTextField.resignFirstResponder()
      
        self.doneBtn.isEnabled = false
        self.saveBtn.isHidden = false
       
    }
//    //⬇️ 키보드 올릴때 뷰올리는걸 노티피케이션을 이용해서 하는거임. 블로그에 올리기 ㄱ
//    func addKeyboardNotification() { // 노티피케이션추가
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    
//    func removeKeyboardNotification() { // 노티피케이션 삭제
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//        
//    }
//    
//  
//    
//    @objc func keyboardWillShow(_ noti: Notification) { // 키보드높이만큼 뷰를 올려준다
//        self.view.frame.origin.y = 100
////        if let  keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
////            let keyboardRectangle = keyboardFrame.cgRectValue
////            let keyboardHight = keyboardRectangle.height
////            self.view.frame.origin.y -= keyboardHight
////            print(" 키보드가 나타날것이다!")
////        }
//    }
//    
//    @objc func keyboardWillHide(_ noti: Notification) {
//        // 키보드의 높이만큼 화면을 내려준다.
//        self.view.frame.origin.y = 0
////            if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
////                let keyboardRectangle = keyboardFrame.cgRectValue
////                let keyboardHeight = keyboardRectangle.height
////                self.view.frame.origin.y += keyboardHeight
////            }
//    }
//    
////    override func viewWillAppear(_ animated: Bool) {
////        self.addKeyboardNotification()
////    }
////    override func viewWillDisappear(_ animated: Bool) {
////        self.removeKeyboardNotification()
////    }
//  
//    //⬆️ 여기까지
    

    
    func saveInTheCoredata() {
        guard let date = dateTextField.text else {return}
        guard let totalVolume = todayTotalLabel.text else {return}
        
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: "HistoryInfo", into: context)
        
        newEntity.setValue(date, forKey: "date")
        newEntity.setValue(totalVolume, forKey: "totalVolume")
        
        if context.hasChanges {
            do {
                try context.save()
                print("코어데이터에 정상적으로 저장되었습니다")
            } catch {
                print("코어데이터저장실패 \(error)")
            }
        }
    }
}


