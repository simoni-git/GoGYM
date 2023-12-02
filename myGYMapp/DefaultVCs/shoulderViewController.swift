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
        viewmodel.shoulderArray.append(data)
        
        let total = weight * Double(count) * Double(set)
        viewmodel.shoulderTotalVolume.append(total)
       
        let totalVol = viewmodel.shoulderTotalVolume.reduce(0.0 , +)
        self.shoulderTotalVolumeLabel.text = "\(String(totalVol))KG" //<< 이부분은 뷰관련
        
        self.tableView.reloadData()
        print("shoulderViewController 에서 프로토콜에대한 sendLegData 메서드가 실행됨.")
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var shoulderTotalVolumeLabel: UILabel!
    
    var viewmodel: ShoulderViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewmodel = ShoulderViewModel()
        
        tableView.dataSource = self
        tableView.delegate = self
        viewmodel.loadDataOfShoulderArray()
        viewmodel.loadDataOfShoulderTotalVolume()
    }
    
    @IBAction func tapAddShoulder(_ sender: UIBarButtonItem) {
        guard let addShoulderVC = self.storyboard?.instantiateViewController(identifier: "addShoulderViewController") as? addShoulderViewController else {return}
        addShoulderVC.shoulderDelegate = self
        self.navigationController?.pushViewController(addShoulderVC, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewmodel.postNotifi()
        viewmodel.saveDataOfShoulderArray()
        viewmodel.saveDataOfShoulderTotalVolume()
    }
}

extension shoulderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.shoulderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "shoulderCell", for: indexPath) as? shoulderCell else {
            return UITableViewCell()
        }
        let data = viewmodel.shoulderArray[indexPath.row]
        cell.kindOfShoulderLabel.text = data.kind
        cell.weightLabel.text = String(data.weight)
        cell.countLabel.text = String(data.count)
        cell.setLabel.text = String(data.set)
        
        let value = (data.weight) * Double(data.count) * Double(data.set)
        cell.shoulderVolumeLabel.text = String(value)+"KG"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            if indexPath.row < viewmodel.shoulderTotalVolume.count {
                viewmodel.shoulderTotalVolume.remove(at: indexPath.row)
            }
            viewmodel.shoulderArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            let total = viewmodel.shoulderTotalVolume.reduce(0.0 , +)
            self.shoulderTotalVolumeLabel.text = "\(String(total))KG"
   
            print("shoulderArray 배열의 아이템이랑 shoulderTotalVolume 배열의 아이템이 하나씩 삭제됨")
            viewmodel.saveDataOfShoulderArray()
            viewmodel.saveDataOfShoulderTotalVolume()
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
