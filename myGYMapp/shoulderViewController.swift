//
//  shoulderViewController.swift
//  myGYMapp
//
//  Created by MAC on 10/24/23.
//

import UIKit

class shoulderViewController: UIViewController , shoulderProtocol {
    
    func sendShoulderData(proShoulderKind: String, proShoulderWeight: Double, proShoulderCount: Int, proShoulderSet: Int) {
        let kind = proShoulderKind
        let weight = proShoulderWeight
        let count = proShoulderCount
        let set = proShoulderSet
        let data = optionList(kind: kind, weight: weight, count: count, set: set)
        self.shoulderArray.append(data)
        
        let total = weight * Double(count) * Double(set)
        self.shoulderTotalVolume.append(total)
        self.tableView.reloadData()
        print("shoulderViewController 에서 프로토콜에대한 sendLegData 메서드가 실행됨.")
    }
    
    var shoulderArray = [optionList]() {
        didSet {
            saveDataOfShoulderArray()
            print("shoulderArray 에 대한 didset 이 호출됨 , shoulderArray 배열의 갯수는 --> \(shoulderArray.count) 개")
        }
    }
    
    var shoulderTotalVolume = [Double]() {
        didSet {
            saveDataOfShoulderTotalVolume()
            let total = shoulderTotalVolume.reduce(0.0 , +)
            self.shoulderTotalVolumeLabel.text = "\(String(total))KG"
            print("shoulderTotalVolume 에 대한 didset 이 호출됨 , shoulderTotalVolume 배열의 갯수는 --> \(shoulderTotalVolume.count)개")
        }
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var shoulderTotalVolumeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        loadDataOfShoulderArray()
        loadDataOfShoulderTotalVolume()
        print(" shoulder view did load 호출됬다~! shoulderArray 의 갯수는 --> \(shoulderArray.count) ,shoulderTotalVolume의 개수는 -->  \(shoulderTotalVolume.count) ")
    }
    
    func saveDataOfShoulderArray() {
        let shoulderData01 = self.shoulderArray.map{
            [
                "kind":$0.kind ,
                "weight": $0.weight ,
                "count": $0.count ,
                "set": $0.set
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(shoulderData01, forKey: "shoulderData01")
        print("shoulderData01 이 userdefault 저장소에 저장되었다.")
    }
    
    func saveDataOfShoulderTotalVolume() {
        let shoulderData02 = self.shoulderTotalVolume
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(shoulderData02, forKey: "shoulderData02")
        print("shoulderData02 이 userdefault 저장소에 저장되었다.")
    }
    
    func loadDataOfShoulderArray() {
        let userDefaults = UserDefaults.standard
        guard let shoulderData01 = userDefaults.object(forKey: "shoulderData01") as? [[String:Any]] else {return}
        self.shoulderArray = shoulderData01.compactMap{
            guard let kind = $0["kind"] as? String else {return nil}
            guard let weight = $0["weight"] as? Double else {return nil}
            guard let count = $0["count"] as? Int else {return nil}
            guard let set = $0["set"] as? Int else {return nil}
            
            return optionList(kind: kind, weight: weight, count: count, set: set)
        }
    }
    
    func loadDataOfShoulderTotalVolume() {
        let userDefaults = UserDefaults.standard
        if let shoulderData02 = userDefaults.array(forKey: "shoulderData02") as? [Double] {
            self.shoulderTotalVolume = shoulderData02
        }
    }
    
    @IBAction func tapAddShoulder(_ sender: UIBarButtonItem) {
        guard let addShoulderVC = self.storyboard?.instantiateViewController(identifier: "addShoulderViewController") as? addShoulderViewController else {return}
        addShoulderVC.shoulderDelegate = self
        self.navigationController?.pushViewController(addShoulderVC, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let total = shoulderTotalVolume.reduce(0.0 , +)
        NotificationCenter.default.post(name: .shoulderFinalTotalVolume, object: Double(total))
        saveDataOfShoulderArray()
        saveDataOfShoulderTotalVolume()
    }
}

extension shoulderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoulderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "shoulderCell", for: indexPath) as? shoulderCell else {
            return UITableViewCell()
        }
        let data = shoulderArray[indexPath.row]
        cell.kindOfShoulderLabel.text = data.kind
        cell.weightLabel.text = String(data.weight)
        cell.countLabel.text = String(data.count)
        cell.setLabel.text = String(data.set)
        
        let value = (data.weight) * Double(data.count) * Double(data.set)
        cell.shoulderVolumeLabel.text = String(value)+"KG"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //⬇️ 이부분 어려워서 참고한부분.
        if editingStyle == .delete {
            if indexPath.row < shoulderTotalVolume.count {
                self.shoulderTotalVolume.remove(at: indexPath.row)
            }
            self.shoulderArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            print("shoulderArray 배열의 아이템이랑 shoulderTotalVolume 배열의 아이템이 하나씩 삭제됨")
            saveDataOfShoulderArray()
            saveDataOfShoulderTotalVolume()
        }
    }
}

extension shoulderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
extension Notification.Name {
    static let shoulderFinalTotalVolume = Notification.Name("shoulderFinalTotalVolume")
}

class shoulderCell: UITableViewCell {
    @IBOutlet var kindOfShoulderLabel: UILabel!
    @IBOutlet var shoulderVolumeLabel: UILabel!
    
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var setLabel: UILabel!
    
    @IBOutlet var KG: UILabel!
    @IBOutlet var 회: UILabel!
    @IBOutlet var 세트: UILabel!
}
