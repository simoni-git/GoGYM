//
//  legViewController.swift
//  myGYMapp
//
//  Created by MAC on 10/24/23.
//

import UIKit

class LegViewController: UIViewController {
    
    var viewmodel: LegViewModel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var legTotalVolumeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewmodel = LegViewModel.shared
        tableView.dataSource = self
        tableView.delegate = self
        viewmodel.loadDataOfLegArray()
        viewmodel.loadDataOfLegTotalVolume()
     
    }
    
    @IBAction func tapAddLeg(_ sender: UIBarButtonItem) {
        guard let addLegVC = self.storyboard?.instantiateViewController(identifier: "AddLegViewController") as? AddLegViewController else {return}
        self.navigationController?.pushViewController(addLegVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear 호출됨, 테이블뷰리로드")
        self.tableView.reloadData()
        
        let total = viewmodel.legTotalVolume.reduce(0.0 , +)
        self.legTotalVolumeLabel.text = "\(String(total))KG"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let total = viewmodel.legTotalVolume.reduce(0.0 , +)
        NotificationCenter.default.post(name: Notification.Name.legFinalTotalVolume, object: Double(total))
        viewmodel.saveDataOfLegArray()
        viewmodel.saveDataOfLegTotalVolume()
    }
}

extension LegViewController: UITableViewDataSource {
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
        //⬇️ 이부분 어려워서 참고한부분.
        if editingStyle == .delete {
            if indexPath.row < viewmodel.legTotalVolume.count {
                viewmodel.legTotalVolume.remove(at: indexPath.row)
            }
            viewmodel.legArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            print("legArray 배열의 아이템이랑 legTotalVolume 배열의 아이템이 하나씩 삭제됨")
            viewmodel.saveDataOfLegArray()
            viewmodel.saveDataOfLegTotalVolume()
            
            //⬇️ totalLabel 구현해줌.
            let totalData = viewmodel.legTotalVolume
            let total = totalData.reduce(0.0 , +)
            self.legTotalVolumeLabel.text = "\(total) KG"
        }
    }
}

extension LegViewController: UITableViewDelegate {
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
