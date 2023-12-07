//
//  legViewController.swift
//  myGYMapp
//
//  Created by MAC on 10/24/23.
//

import UIKit

class legViewController: UIViewController {
    
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
    
    var legArray = [optionList]() {
        didSet {
            saveDataOfLegArray()
            print("legArray 에 대한 didset 이 호출됨 , legArray 배열의 갯수는 --> \(legArray.count) 개")
        }
    }
    
    var legTotalVolume = [Double]() {
        didSet {
            saveDataOfLegTotalVolume()
            let total = legTotalVolume.reduce(0.0 , +)
            self.legTotalVolumeLabel.text = "\(String(total))KG"
            print("legTotalVolume 에 대한 didset 이 호출됨 , legTotalVolume 배열의 갯수는 --> \(legTotalVolume.count)개")
        }
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var legTotalVolumeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        loadDataOfLegArray()
        loadDataOfLegTotalVolume()
        print(" Legview did load 호출됬다~! legArray 의 갯수는 --> \(legArray.count) ,legTotalVolume의 개수는 -->  \(legTotalVolume.count) ")
    }
    
    func saveDataOfLegArray() {
        let legData01 = self.legArray.map{
            [
                "kind":$0.kind ,
                "weight": $0.weight ,
                "count": $0.count ,
                "set": $0.set
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(legData01, forKey: "legData01")
        print("legData01 이 userdefault 저장소에 저장되었다.")
    }
    
    func saveDataOfLegTotalVolume() {
        let legData02 = self.legTotalVolume
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(legData02, forKey: "legData02")
        print("legData02 이 userdefault 저장소에 저장되었다.")
    }
    
    func loadDataOfLegArray() {
        let userDefaults = UserDefaults.standard
        guard let legData01 = userDefaults.object(forKey: "legData01") as? [[String:Any]] else {return}
        self.legArray = legData01.compactMap{
            guard let kind = $0["kind"] as? String else {return nil}
            guard let weight = $0["weight"] as? Double else {return nil}
            guard let count = $0["count"] as? Int else {return nil}
            guard let set = $0["set"] as? Int else {return nil}
            
            return optionList(kind: kind, weight: weight, count: count, set: set)
        }
    }
    
    func loadDataOfLegTotalVolume() {
        let userDefaults = UserDefaults.standard
        if let legData02 = userDefaults.array(forKey: "legData02") as? [Double] {
            self.legTotalVolume = legData02
        }
    }
    
    @IBAction func tapAddLeg(_ sender: UIBarButtonItem) {
        guard let addLegVC = self.storyboard?.instantiateViewController(identifier: "addLegViewController") as? addLegViewController else {return}
        self.navigationController?.pushViewController(addLegVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear 호출됨, 테이블뷰리로드")
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let total = legTotalVolume.reduce(0.0 , +)
        NotificationCenter.default.post(name: Notification.Name.legFinalTotalVolume, object: Double(total))
        saveDataOfLegArray()
        saveDataOfLegTotalVolume()
    }
}

extension legViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return legArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "legCell", for: indexPath) as? legCell else {
            return UITableViewCell()
        }
        let data = legArray[indexPath.row]
        cell.kindOfLegLabel.text = data.kind
        cell.weightLabel.text = String(data.weight)
        cell.countLabel.text = String(data.count)
        cell.setLabel.text = String(data.set)
        
        let value = (data.weight) * Double(data.count) * Double(data.set)
        cell.legVolumeLabel.text = String(value)+"KG"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //⬇️ 이부분 어려워서 참고한부분.
        if editingStyle == .delete {
            if indexPath.row < legTotalVolume.count {
                self.legTotalVolume.remove(at: indexPath.row)
            }
            self.legArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            print("legArray 배열의 아이템이랑 legTotalVolume 배열의 아이템이 하나씩 삭제됨")
            saveDataOfLegArray()
            saveDataOfLegTotalVolume()
        }
    }
}

extension legViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension Notification.Name {
    static let legFinalTotalVolume = Notification.Name("legFinalTotalVolume")
}

class legCell: UITableViewCell {
    @IBOutlet var kindOfLegLabel: UILabel!
    @IBOutlet var legVolumeLabel: UILabel!
    
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var setLabel: UILabel!
    
    @IBOutlet var KG: UILabel!
    @IBOutlet var 회: UILabel!
    @IBOutlet var 세트: UILabel!
}
