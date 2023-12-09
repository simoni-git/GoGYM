//
//  backViewController.swift
//  myGYMapp
//
//  Created by MAC on 10/24/23.
//

import UIKit

class BackViewController: UIViewController {
    
    var viewmodel: BackViewModel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var backTotalVolumeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewmodel = BackViewModel.shared
        tableView.dataSource = self
        tableView.delegate = self
        viewmodel.loadDataOfbackArray()
        viewmodel.loadDataOfbackTotalVolume()
        
    }
    
    @IBAction func tapAddBack(_ sender: UIBarButtonItem) {
        
        guard let addBackVC = self.storyboard?.instantiateViewController(identifier: "AddBackViewController") as? AddBackViewController else {return}
        self.navigationController?.pushViewController(addBackVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear 호출됨, 테이블뷰리로드")
        self.tableView.reloadData()
        
        let total = viewmodel.backTotalVolume.reduce(0.0 , +)
        self.backTotalVolumeLabel.text = "\(String(total))KG"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let total = viewmodel.backTotalVolume.reduce(0.0 , +)
        NotificationCenter.default.post(name: .backFinalTotalVolume, object: Double(total))
        viewmodel.saveDataOfBackArray()
        viewmodel.saveDataOfBackTotalVolume()
    }
}

extension BackViewController: UITableViewDataSource {
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
        //⬇️ 이부분 어려워서 참고한부분.
        if editingStyle == .delete {
            if indexPath.row < viewmodel.backTotalVolume.count {
                viewmodel.backTotalVolume.remove(at: indexPath.row)
            }
            viewmodel.backArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            print("backArray 배열의 아이템이랑 backTotalVolume 배열의 아이템이 하나씩 삭제됨")
            viewmodel.saveDataOfBackArray()
            viewmodel.saveDataOfBackTotalVolume()
            
            //⬇️ totalLabel 구현해줌.
            let totalData = viewmodel.backTotalVolume
            let total = totalData.reduce(0.0 , +)
            self.backTotalVolumeLabel.text = "\(total) KG"
        }
    }
}

extension BackViewController: UITableViewDelegate {
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
