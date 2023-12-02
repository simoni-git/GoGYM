//
//  backViewController.swift
//  myGYMapp
//
//  Created by MAC on 10/24/23.
//

import UIKit

class backViewController: UIViewController , backProtocl{
    
    func sendBackData(proBackKind: String, proBackWeight: Double, proBackCount: Int, proBackSet: Int) {
        let kind = proBackKind
        let weight = proBackWeight
        let count = proBackCount
        let set = proBackSet
        let data = optionList(kind: kind, weight: weight, count: count, set: set)
        viewmodel.backArray.append(data)
        
        let total = weight * Double(count) * Double(set)
        viewmodel.backTotalVolume.append(total)
       
        let totalVol = viewmodel.backTotalVolume.reduce(0.0 , +)
        self.backTotalVolumeLabel.text = "\(String(totalVol))KG" //<< 이부분은 뷰관련
      
        self.tableView.reloadData()
        print("backViewController 에서 프로토콜에대한 sendBackData 메서드가 실행됨.")
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var backTotalVolumeLabel: UILabel!
    
    var viewmodel: BackViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewmodel = BackViewModel()
        
        tableView.dataSource = self
        tableView.delegate = self
        viewmodel.loadDataOfbackArray()
        viewmodel.loadDataOfbackTotalVolume()
       
    }
    
    @IBAction func tapAddBack(_ sender: UIBarButtonItem) {
        
        guard let addBackVC = self.storyboard?.instantiateViewController(identifier: "addBackViewController") as? addBackViewController else {return}
        addBackVC.backDelegate = self
        self.navigationController?.pushViewController(addBackVC, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewmodel.postNotifi()
        viewmodel.saveDataOfBackArray()
        viewmodel.saveDataOfBackTotalVolume()
    }
}

extension backViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.backArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "backCell", for: indexPath) as? backCell else {
            return UITableViewCell()
        }
        let data = viewmodel.backArray[indexPath.row]
        cell.kindOfBackLabel.text = data.kind
        cell.weightLabel.text = String(data.weight)
        cell.countLabel.text = String(data.count)
        cell.setLabel.text = String(data.set)
        
        let value = (data.weight) * Double(data.count) * Double(data.set)
        cell.backVolumeLabel.text = String(value)+"KG"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            if indexPath.row < viewmodel.backTotalVolume.count {
                viewmodel.backTotalVolume.remove(at: indexPath.row)
             
            }
            viewmodel.backArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            let total = viewmodel.backTotalVolume.reduce(0.0 , +)
            self.backTotalVolumeLabel.text = "\(String(total))KG"//뷰관련
            
            print("backArray 배열의 아이템이랑 backTotalVolume 배열의 아이템이 하나씩 삭제됨")
            viewmodel.saveDataOfBackArray()
            viewmodel.saveDataOfBackTotalVolume()
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
