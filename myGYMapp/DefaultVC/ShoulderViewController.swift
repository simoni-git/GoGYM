//
//  shoulderViewController.swift
//  myGYMapp
//
//  Created by MAC on 10/24/23.
//

import UIKit

class ShoulderViewController: UIViewController {
    
    var viewmodel: ShoulderViewModel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var shoulderTotalVolumeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewmodel = ShoulderViewModel.shared
        tableView.dataSource = self
        tableView.delegate = self
        viewmodel.loadDataOfShoulderArray()
        viewmodel.loadDataOfShoulderTotalVolume()
        
    }
    
    @IBAction func tapAddShoulder(_ sender: UIBarButtonItem) {
        guard let addShoulderVC = self.storyboard?.instantiateViewController(identifier: "AddShoulderViewController") as? AddShoulderViewController else {return}
        self.navigationController?.pushViewController(addShoulderVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear 호출됨, 테이블뷰리로드")
        self.tableView.reloadData()
        
        let total = viewmodel.shoulderTotalVolume.reduce(0.0 , +)
        self.shoulderTotalVolumeLabel.text = "\(String(total))KG"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let total = viewmodel.shoulderTotalVolume.reduce(0.0 , +)
        NotificationCenter.default.post(name: .shoulderFinalTotalVolume, object: Double(total))
        viewmodel.saveDataOfShoulderArray()
        viewmodel.saveDataOfShoulderTotalVolume()
    }
}

extension ShoulderViewController: UITableViewDataSource {
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
        //⬇️ 이부분 어려워서 참고한부분.
        if editingStyle == .delete {
            if indexPath.row < viewmodel.shoulderTotalVolume.count {
                viewmodel.shoulderTotalVolume.remove(at: indexPath.row)
            }
            viewmodel.shoulderArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            print("shoulderArray 배열의 아이템이랑 shoulderTotalVolume 배열의 아이템이 하나씩 삭제됨")
            viewmodel.saveDataOfShoulderArray()
            viewmodel.saveDataOfShoulderTotalVolume()
            
            //⬇️ totalLabel 구현해줌.
            let totalData = viewmodel.shoulderTotalVolume
            let total = totalData.reduce(0.0 , +)
            self.shoulderTotalVolumeLabel.text = "\(total) KG"
        }
    }
}

extension ShoulderViewController: UITableViewDelegate {
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
