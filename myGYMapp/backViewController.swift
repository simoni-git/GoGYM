//
//  backViewController.swift
//  myGYMapp
//
//  Created by MAC on 10/24/23.
//

import UIKit
 

class backViewController: UIViewController {
    
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
    
    var backArray = [optionList]() {
        didSet {
            saveDataOfBackArray()
            print("backArray 에 대한 didset 이 호출됨 , backArray 배열의 갯수는 --> \(backArray.count) 개")
        }
    }
    
    var backTotalVolume = [Double]() {
        didSet {
            saveDataOfBackTotalVolume()
            let total = backTotalVolume.reduce(0.0 , +)
            self.backTotalVolumeLabel.text = "\(String(total))KG"
            print("backTotalVolume 에 대한 didset 이 호출됨 , backTotalVolume 배열의 갯수는 --> \(backTotalVolume.count)개")
        }
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var backTotalVolumeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        loadDataOfbackArray()
        loadDataOfbackTotalVolume()
        print(" Backview did load 호출됬다~! backArray 의 갯수는 --> \(backArray.count) ,backTotalVolume의 개수는 -->  \(backTotalVolume.count) ")
    }
    
    func saveDataOfBackArray() {
        let backData01 = self.backArray.map{
            [
                "kind":$0.kind ,
                "weight": $0.weight ,
                "count": $0.count ,
                "set": $0.set
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(backData01, forKey: "backData01")
        print("backData01 이 userdefault 저장소에 저장되었다.")
    }
    
    func saveDataOfBackTotalVolume() {
        let backData02 = self.backTotalVolume
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(backData02, forKey: "backData02")
        print("backData02 이 userdefault 저장소에 저장되었다.")
    }
    
    func loadDataOfbackArray() {
        let userDefaults = UserDefaults.standard
        guard let backData01 = userDefaults.object(forKey: "backData01") as? [[String:Any]] else {return}
        self.backArray = backData01.compactMap{
            guard let kind = $0["kind"] as? String else {return nil}
            guard let weight = $0["weight"] as? Double else {return nil}
            guard let count = $0["count"] as? Int else {return nil}
            guard let set = $0["set"] as? Int else {return nil}
            
            return optionList(kind: kind, weight: weight, count: count, set: set)
        }
    }
    
    func loadDataOfbackTotalVolume() {
        let userDefaults = UserDefaults.standard
        if let backData02 = userDefaults.array(forKey: "backData02") as? [Double] {
            self.backTotalVolume = backData02
        }
    }
    
    @IBAction func tapAddBack(_ sender: UIBarButtonItem) {
        
        guard let addBackVC = self.storyboard?.instantiateViewController(identifier: "addBackViewController") as? addBackViewController else {return}
        self.navigationController?.pushViewController(addBackVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear 호출됨, 테이블뷰리로드")
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let total = backTotalVolume.reduce(0.0 , +)
        NotificationCenter.default.post(name: .backFinalTotalVolume, object: Double(total))
        saveDataOfBackArray()
        saveDataOfBackTotalVolume()
    }
}

extension backViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return backArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "backCell", for: indexPath) as? backCell else {
            return UITableViewCell()
        }
        let data = backArray[indexPath.row]
        cell.kindOfBackLabel.text = data.kind
        cell.weightLabel.text = String(data.weight)
        cell.countLabel.text = String(data.count)
        cell.setLabel.text = String(data.set)
        
        let value = (data.weight) * Double(data.count) * Double(data.set)
        cell.backVolumeLabel.text = String(value)+"KG"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //⬇️ 이부분 어려워서 참고한부분.
        if editingStyle == .delete {
            if indexPath.row < backTotalVolume.count {
                self.backTotalVolume.remove(at: indexPath.row)
            }
            self.backArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            print("backArray 배열의 아이템이랑 backTotalVolume 배열의 아이템이 하나씩 삭제됨")
            saveDataOfBackArray()
            saveDataOfBackTotalVolume()
        }
    }
}

extension backViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension Notification.Name {
    static let backFinalTotalVolume = Notification.Name("backFinalTotalVolume")
}

class backCell: UITableViewCell {
    @IBOutlet var kindOfBackLabel: UILabel!
    @IBOutlet var backVolumeLabel: UILabel!
    
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var setLabel: UILabel!
    
    @IBOutlet var KG: UILabel!
    @IBOutlet var 회: UILabel!
    @IBOutlet var 세트: UILabel!
}
