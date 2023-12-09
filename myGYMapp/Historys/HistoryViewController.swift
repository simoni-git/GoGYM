//
//  historyViewController.swift
//  myGYMapp
//
//  Created by MAC on 10/24/23.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {
    
    var viewmodel: HistoryViewModel!
    
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewmodel = HistoryViewModel()
        self.tableview.dataSource = self
        self.tableview.delegate = self
        viewmodel.readData()
    }
    
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.savelist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistroyCell", for: indexPath) as? HistroyCell else {
            return UITableViewCell()
        }
        let data = viewmodel.savelist[indexPath.row]
        cell.dateLabel.text = data.date
        cell.totalVolumeLabel.text = data.totalVolume
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let data = viewmodel.savelist[indexPath.row]
            viewmodel.deleteData(data)
            self.tableview.reloadData()
        }
    }
    
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
}

class HistroyCell: UITableViewCell {
    
    @IBOutlet var 날짜: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var 총볼륨: UILabel!
    @IBOutlet var totalVolumeLabel: UILabel!
    
}
