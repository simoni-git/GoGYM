//
//  chestViewController.swift
//  myGYMapp
//
//  Created by MAC on 10/24/23.
//

import UIKit

class ChestViewController: UIViewController {
    
    var viewmodel: ChestViewModel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var chestTotalVolumeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewmodel = ChestViewModel()
        tableView.dataSource = self
        tableView.delegate = self
        viewmodel.loadDataOfChestArray()
        viewmodel.loadDataOfChestTotalVolume()
        
    }
    
    @IBAction func tapAddChest(_ sender: UIBarButtonItem) {
        
        guard let addChestVC = self.storyboard?.instantiateViewController(identifier: "AddChestViewController") as? AddChestViewController else {return}
        addChestVC.chestVM = self.viewmodel
        
        self.navigationController?.pushViewController(addChestVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear 호출됨, 테이블뷰리로드 , chestArray 배열 갯수는 --> \(viewmodel.chestArray.count)")
        
        self.tableView.reloadData()
        let total = viewmodel.chestTotalVolume.reduce(0.0 , +)
        self.chestTotalVolumeLabel.text = "\(String(total))KG"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let total = viewmodel.chestTotalVolume.reduce(0.0 , +)
        NotificationCenter.default.post(name: Notification.Name.chestFinalTotalVolume, object: Double(total))
        
        viewmodel.saveDataOfChestArray()
        viewmodel.saveDataOfChestTotalVolume()
    }
}

extension ChestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.chestArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "chestCell", for: indexPath) as? chestCell else {
            return UITableViewCell()
        }
        let data = viewmodel.chestArray[indexPath.row]
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
            if indexPath.row < viewmodel.chestTotalVolume.count {
                viewmodel.chestTotalVolume.remove(at: indexPath.row)
            }
            viewmodel.chestArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            print("chestArray 배열의 아이템이랑 chestTotalVolume 배열의 아이템이 하나씩 삭제됨")
            viewmodel.saveDataOfChestArray()
            viewmodel.saveDataOfChestTotalVolume()
            
            //⬇️ totalLabel 구현해줌.
            let totalData = viewmodel.chestTotalVolume
            let total = totalData.reduce(0.0 , +)
            self.chestTotalVolumeLabel.text = "\(total) KG"
        }
    }
}

extension ChestViewController: UITableViewDelegate {
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

