//
//  chestViewController.swift
//  myGYMapp
//
//  Created by MAC on 10/24/23.
//

import UIKit



class chestViewController: UIViewController , chestProtocl {
    
    func sendChestData(proChestKind: String, proChestWeight: Double, proChestCount: Int, proChestSet: Int) {
        let kind = proChestKind
        let weight = proChestWeight
        let count = proChestCount
        let set = proChestSet
        let data = optionList(kind: kind, weight: weight, count: count, set: set)
        viewmodel.chestArray.append(data)
        
        let total = weight * Double(count) * Double(set)
        viewmodel.chestTotalVolume.append(total)
        
        let totalVol = viewmodel.chestTotalVolume.reduce(0.0 , +)
        self.chestTotalVolumeLabel.text = "\(String(totalVol))KG" //<< 이부분은 뷰관련

        self.tableView.reloadData()
        print("chestViewController 에서 프로토콜에대한 sendChestData 메서드가 실행됨.")
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var chestTotalVolumeLabel: UILabel!
    
    var viewmodel: ChestViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewmodel = ChestViewModel()
        
        tableView.dataSource = self
        tableView.delegate = self
        viewmodel.loadDataOfChestArray()
        viewmodel.loadDataOfChestTotalVolume()

    }
    
    @IBAction func tapAddChest(_ sender: UIBarButtonItem) {
        
        guard let addChestVC = self.storyboard?.instantiateViewController(identifier: "addChestViewController") as? addChestViewController else {return}
        addChestVC.chestDelegate = self
        self.navigationController?.pushViewController(addChestVC, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewmodel.postNotifi()
        viewmodel.saveDataOfChestArray()
        viewmodel.saveDataOfChestTotalVolume()
    
    }
}

extension chestViewController: UITableViewDataSource {
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
      
        if editingStyle == .delete {
            if indexPath.row < viewmodel.chestTotalVolume.count {
                viewmodel.chestTotalVolume.remove(at: indexPath.row)
            }
            viewmodel.chestArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            let total = viewmodel.chestTotalVolume.reduce(0.0 , +)// << 뷰관련 작성1
            self.chestTotalVolumeLabel.text = "\(String(total))KG" //<< 뷰관련 작성2

            print("chestArray 배열의 아이템이랑 chestTotalVolume 배열의 아이템이 하나씩 삭제됨")
            viewmodel.saveDataOfChestArray()
            viewmodel.saveDataOfChestTotalVolume()

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

