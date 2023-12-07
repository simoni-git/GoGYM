//
//  armViewController.swift
//  myGYMapp
//
//  Created by MAC on 10/24/23.
//

import UIKit

class armViewController: UIViewController {
    
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
   
    
    var armArray = [optionList]() {
        didSet {
            saveDataOfArmArray()
            print("armArray 에 대한 didset 이 호출됨 , armArray 배열의 갯수는 --> \(armArray.count) 개")
        }
    }
    
    var armTotalVolume = [Double]() {
        didSet {
            saveDataOfArmTotalVolume()
            let total = armTotalVolume.reduce(0.0 , +)
            self.armTotalVolumeLabel.text = "\(String(total))KG"
            print("armTotalVolume 에 대한 didset 이 호출됨 , armTotalVolume 배열의 갯수는 --> \(armTotalVolume.count)개")
        }
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var armTotalVolumeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        loadDataOfArmArray()
        loadDataOfArmTotalVolume()
        print(" arm view did load 호출됬다~! armArray 의 갯수는 --> \(armArray.count) ,armTotalVolume의 개수는 -->  \(armTotalVolume.count) ")
    }
    
    func saveDataOfArmArray() {
        let armData01 = self.armArray.map{
            [
                "kind":$0.kind ,
                "weight": $0.weight ,
                "count": $0.count ,
                "set": $0.set
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(armData01, forKey: "armData01")
        print("armData01 이 userdefault 저장소에 저장되었다.")
    }
    
    func saveDataOfArmTotalVolume() {
        let armData02 = self.armTotalVolume
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(armData02, forKey: "armData02")
        print("armData02 이 userdefault 저장소에 저장되었다.")
    }
    
    func loadDataOfArmArray() {
        let userDefaults = UserDefaults.standard
        guard let armData01 = userDefaults.object(forKey: "armData01") as? [[String:Any]] else {return}
        self.armArray = armData01.compactMap{
            guard let kind = $0["kind"] as? String else {return nil}
            guard let weight = $0["weight"] as? Double else {return nil}
            guard let count = $0["count"] as? Int else {return nil}
            guard let set = $0["set"] as? Int else {return nil}
            
            return optionList(kind: kind, weight: weight, count: count, set: set)
        }
    }
    
    func loadDataOfArmTotalVolume() {
        let userDefaults = UserDefaults.standard
        if let armData02 = userDefaults.array(forKey: "armData02") as? [Double] {
            self.armTotalVolume = armData02
        }
    }
    
    @IBAction func tapAddArm(_ sender: UIBarButtonItem) {
        guard let addArmVC = self.storyboard?.instantiateViewController(identifier: "addArmViewController") as? addArmViewController else {return}
        self.navigationController?.pushViewController(addArmVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear 호출됨, 테이블뷰리로드")
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let total = armTotalVolume.reduce(0.0 , +)
        NotificationCenter.default.post(name: Notification.Name.armFinalTotalVolume, object: Double(total))
        saveDataOfArmArray()
        saveDataOfArmTotalVolume()
    }
}

extension armViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return armArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "armCell", for: indexPath) as? armCell else {
            return UITableViewCell()
        }
        let data = armArray[indexPath.row]
        cell.kindOfArmLabel.text = data.kind
        cell.weightLabel.text = String(data.weight)
        cell.countLabel.text = String(data.count)
        cell.setLabel.text = String(data.set)
        
        let value = (data.weight) * Double(data.count) * Double(data.set)
        cell.armVolumeLabel.text = String(value)+"KG"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //⬇️ 이부분 어려워서 참고한부분.
        if editingStyle == .delete {
            if indexPath.row < armTotalVolume.count {
                self.armTotalVolume.remove(at: indexPath.row)
            }
            self.armArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            print("armArray 배열의 아이템이랑 armTotalVolume 배열의 아이템이 하나씩 삭제됨")
            saveDataOfArmArray()
            saveDataOfArmTotalVolume()
        }
    }
}

extension armViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension Notification.Name {
    static let armFinalTotalVolume = Notification.Name("armFinalTotalVolume")
}

class armCell: UITableViewCell {
    @IBOutlet var kindOfArmLabel: UILabel!
    @IBOutlet var armVolumeLabel: UILabel!
    
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var setLabel: UILabel!
    
    @IBOutlet var KG: UILabel!
    @IBOutlet var 회: UILabel!
    @IBOutlet var 세트: UILabel!
}
