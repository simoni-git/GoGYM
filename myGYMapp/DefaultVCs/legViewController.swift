//
//  legViewController.swift
//  myGYMapp
//
//  Created by MAC on 10/24/23.
//

import UIKit

class legViewController: UIViewController , legProtocol {
    
    func sendLegData(proLegKind: String, proLegWeight: Double, proLegCount: Int, proLegSet: Int) {
        let kind = proLegKind
        let weight = proLegWeight
        let count = proLegCount
        let set = proLegSet
        let data = optionList(kind: kind, weight: weight, count: count, set: set)
        viewmodel.legArray.append(data)
        
        let total = weight * Double(count) * Double(set)
        viewmodel.legTotalVolume.append(total)
        
        
        let totalVol = viewmodel.legTotalVolume.reduce(0.0 , +)
        self.legTotalVolumeLabel.text = "\(String(totalVol))KG" //<< 이부분은 뷰관련
        
        self.tableView.reloadData()
        print("legViewController 에서 프로토콜에대한 sendLegData 메서드가 실행됨.")
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var legTotalVolumeLabel: UILabel!
    var viewmodel: LegViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewmodel = LegViewModel()
        
        tableView.dataSource = self
        tableView.delegate = self
        viewmodel.loadDataOfLegArray()
        viewmodel.loadDataOfLegTotalVolume()
    }
    
    @IBAction func tapAddLeg(_ sender: UIBarButtonItem) {
        guard let addLegVC = self.storyboard?.instantiateViewController(identifier: "addLegViewController") as? addLegViewController else {return}
        addLegVC.legDelegate = self
        self.navigationController?.pushViewController(addLegVC, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewmodel.postNotifi()
        viewmodel.saveDataOfLegArray()
        viewmodel.saveDataOfLegTotalVolume()

    }
}

extension legViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.legArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "legCell", for: indexPath) as? legCell else {
            return UITableViewCell()
        }
        let data = viewmodel.legArray[indexPath.row]
        cell.kindOfLegLabel.text = data.kind
        cell.weightLabel.text = String(data.weight)
        cell.countLabel.text = String(data.count)
        cell.setLabel.text = String(data.set)
        
        let value = (data.weight) * Double(data.count) * Double(data.set)
        cell.legVolumeLabel.text = String(value)+"KG"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
        if editingStyle == .delete {
            if indexPath.row < viewmodel.legTotalVolume.count {
                viewmodel.legTotalVolume.remove(at: indexPath.row)
            }
            viewmodel.legArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            let total = viewmodel.legTotalVolume.reduce(0.0 , +)
            self.legTotalVolumeLabel.text = "\(String(total))KG"
            
            print("legArray 배열의 아이템이랑 legTotalVolume 배열의 아이템이 하나씩 삭제됨")
            viewmodel.saveDataOfLegArray()
            viewmodel.saveDataOfLegTotalVolume()
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
