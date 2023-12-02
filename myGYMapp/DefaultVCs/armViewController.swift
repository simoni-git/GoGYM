//
//  armViewController.swift
//  myGYMapp
//
//  Created by MAC on 10/24/23.
//

import UIKit

class armViewController: UIViewController , armProtocol {
    
    func sendArmData(proArmKind: String, proArmWeight: Double, proArmCount: Int, proArmSet: Int) {
        let kind = proArmKind
        let weight = proArmWeight
        let count = proArmCount
        let set = proArmSet
        let data = optionList(kind: kind, weight: weight, count: count, set: set)
        viewmodel.armArray.append(data)
        
        let total = weight * Double(count) * Double(set)
        viewmodel.armTotalVolume.append(total)
       
        let totalVol = viewmodel.armTotalVolume.reduce(0.0 , +)
        self.armTotalVolumeLabel.text = "\(String(totalVol))KG" //<< 이부분은 뷰관련
        
        self.tableView.reloadData()
        print("armViewController 에서 프로토콜에대한 sendArmData 메서드가 실행됨.")
    }

    @IBOutlet var tableView: UITableView!
    @IBOutlet var armTotalVolumeLabel: UILabel!
    var viewmodel: ArmViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewmodel = ArmViewModel()
        
        tableView.dataSource = self
        tableView.delegate = self
        viewmodel.loadDataOfArmArray()
        viewmodel.loadDataOfArmTotalVolume()
    }
    
    @IBAction func tapAddArm(_ sender: UIBarButtonItem) {
        guard let addArmVC = self.storyboard?.instantiateViewController(identifier: "addArmViewController") as? addArmViewController else {return}
        addArmVC.armDelegate = self
        self.navigationController?.pushViewController(addArmVC, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewmodel.postNotifi()
        viewmodel.saveDataOfArmArray()
        viewmodel.saveDataOfArmTotalVolume()
    }
}

extension armViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.armArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "armCell", for: indexPath) as? armCell else {
            return UITableViewCell()
        }
        let data = viewmodel.armArray[indexPath.row]

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
            if indexPath.row < viewmodel.armTotalVolume.count {
                viewmodel.armTotalVolume.remove(at: indexPath.row)
             
//            if indexPath.row < armTotalVolume.count {
//                self.armTotalVolume.remove(at: indexPath.row)
            }
            viewmodel.armArray.remove(at: indexPath.row)
//            self.armArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            let total = viewmodel.armTotalVolume.reduce(0.0 , +)
            self.armTotalVolumeLabel.text = "\(String(total))KG"
            
            print("armArray 배열의 아이템이랑 armTotalVolume 배열의 아이템이 하나씩 삭제됨")
            viewmodel.saveDataOfArmArray()
            viewmodel.saveDataOfArmTotalVolume()
//            saveDataOfArmArray()
//            saveDataOfArmTotalVolume()
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
