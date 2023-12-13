//
//  armViewController.swift
//  myGYMapp
//
//  Created by MAC on 10/24/23.
//

import UIKit

class ArmViewController: UIViewController {
    
    var viewmodel: ArmViewModel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var armTotalVolumeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewmodel = ArmViewModel()
        tableView.dataSource = self
        tableView.delegate = self
        viewmodel.loadDataOfArmArray()
        viewmodel.loadDataOfArmTotalVolume()
        
    }
    
    @IBAction func tapAddArm(_ sender: UIBarButtonItem) {
        guard let addArmVC = self.storyboard?.instantiateViewController(identifier: "AddArmViewController") as? AddArmViewController else {return}
        addArmVC.armVM = self.viewmodel
        self.navigationController?.pushViewController(addArmVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear 호출됨, 테이블뷰리로드")
        self.tableView.reloadData()
        
        let total = viewmodel.armTotalVolume.reduce(0.0 , +)
        self.armTotalVolumeLabel.text = "\(String(total))KG"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let total = viewmodel.armTotalVolume.reduce(0.0 , +)
        NotificationCenter.default.post(name: Notification.Name.armFinalTotalVolume, object: Double(total))
        viewmodel.saveDataOfArmArray()
        viewmodel.saveDataOfArmTotalVolume()
    }
}

extension ArmViewController: UITableViewDataSource {
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
            }
            viewmodel.armArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            print("armArray 배열의 아이템이랑 armTotalVolume 배열의 아이템이 하나씩 삭제됨")
            viewmodel.saveDataOfArmArray()
            viewmodel.saveDataOfArmTotalVolume()
            
            //⬇️ totalLabel 구현해줌.
            let totalData = viewmodel.armTotalVolume
            let total = totalData.reduce(0.0 , +)
            self.armTotalVolumeLabel.text = "\(total) KG"
        }
    }
}

extension ArmViewController: UITableViewDelegate {
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
