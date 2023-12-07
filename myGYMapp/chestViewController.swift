//
//  chestViewController.swift
//  myGYMapp
//
//  Created by MAC on 10/24/23.
//

import UIKit

class chestViewController: UIViewController {
    
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
    
    
    var chestArray = [optionList]() {
        didSet {
            saveDataOfChestArray()
            print("chestArray 에 대한 didset 이 호출됨 , chestArray 배열의 갯수는 --> \(chestArray.count) 개")
        }
    }
    
    var chestTotalVolume = [Double]() {
        didSet {
            saveDataOfChestTotalVolume()
            let total = chestTotalVolume.reduce(0.0 , +)
            self.chestTotalVolumeLabel.text = "\(String(total))KG"
            print("chestTotalVolume 에 대한 didset 이 호출됨 , chestTotalVolume 배열의 갯수는 --> \(chestTotalVolume.count)개")
        }
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var chestTotalVolumeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        loadDataOfChestArray()
        loadDataOfChestTotalVolume()
        print(" chestViewController 의 view did load 호출됬다~! chestArray 의 갯수는 --> \(chestArray.count) ,chestTotalVolume의 개수는 -->  \(chestTotalVolume.count) ")
    }
    
    func saveDataOfChestArray() {
        let chestData01 = self.chestArray.map{
            [
                "kind":$0.kind ,
                "weight": $0.weight ,
                "count": $0.count ,
                "set": $0.set
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(chestData01, forKey: "chestData01")
        print("chestData01 이 userdefault 저장소에 저장되었다.")
    }
    
    func saveDataOfChestTotalVolume() {
        let chestData02 = self.chestTotalVolume
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(chestData02, forKey: "chestData02")
        print("chestData02 이 userdefault 저장소에 저장되었다.")
    }
    
    func loadDataOfChestArray() {
        let userDefaults = UserDefaults.standard
        guard let chestData01 = userDefaults.object(forKey: "chestData01") as? [[String:Any]] else {return}
        self.chestArray = chestData01.compactMap{
            guard let kind = $0["kind"] as? String else {return nil}
            guard let weight = $0["weight"] as? Double else {return nil}
            guard let count = $0["count"] as? Int else {return nil}
            guard let set = $0["set"] as? Int else {return nil}
            
            return optionList(kind: kind, weight: weight, count: count, set: set)
        }
    }
    
    func loadDataOfChestTotalVolume() {
        let userDefaults = UserDefaults.standard
        if let chestData02 = userDefaults.array(forKey: "chestData02") as? [Double] {
            self.chestTotalVolume = chestData02
        }
    }
    
    @IBAction func tapAddChest(_ sender: UIBarButtonItem) {
        
        guard let addChestVC = self.storyboard?.instantiateViewController(identifier: "addChestViewController") as? addChestViewController else {return}
      
        self.navigationController?.pushViewController(addChestVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear 호출됨, 테이블뷰리로드")
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let total = chestTotalVolume.reduce(0.0 , +)
        NotificationCenter.default.post(name: Notification.Name.chestFinalTotalVolume, object: Double(total))
      
        saveDataOfChestArray()
        saveDataOfChestTotalVolume()
    }
}

extension chestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chestArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "chestCell", for: indexPath) as? chestCell else {
            return UITableViewCell()
        }
        let data = chestArray[indexPath.row]
        cell.kindOfChestLabel.text = data.kind
        cell.weightLabel.text = String(data.weight)
        cell.countLabel.text = String(data.count)
        cell.setLabel.text = String(data.set)
        
        let value = (data.weight) * Double(data.count) * Double(data.set)
        cell.chestVolumeLabel.text = String(value)+"KG"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //⬇️ 이부분 어려워서 참고한부분.
        if editingStyle == .delete {
            if indexPath.row < chestTotalVolume.count {
                self.chestTotalVolume.remove(at: indexPath.row)
            }
            self.chestArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            print("chestArray 배열의 아이템이랑 chestTotalVolume 배열의 아이템이 하나씩 삭제됨")
            saveDataOfChestArray()
            saveDataOfChestTotalVolume()
        }
    }
}

extension chestViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension Notification.Name {
    static let chestFinalTotalVolume = Notification.Name("chestFinalTotalVolume")
}

class chestCell: UITableViewCell {
    @IBOutlet var kindOfChestLabel: UILabel!
    @IBOutlet var chestVolumeLabel: UILabel!
    
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var setLabel: UILabel!
    
    @IBOutlet var KG: UILabel!
    @IBOutlet var 회: UILabel!
    @IBOutlet var 세트: UILabel!
}

