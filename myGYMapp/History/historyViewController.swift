//
//  historyViewController.swift
//  myGYMapp
//
//  Created by MAC on 10/24/23.
//

import UIKit
import CoreData

class historyViewController: UIViewController {
    
    @IBOutlet var tableview: UITableView!
    var viewmodel: HistoryViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewmodel = HistoryViewModel()
        
        self.tableview.dataSource = self
        self.tableview.delegate = self
        viewmodel.ReadData()
        self.tableview.reloadData()

    }
}

extension historyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.savelist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "histroyCell", for: indexPath) as? histroyCell else {
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

extension historyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
}

class histroyCell: UITableViewCell {
    
    @IBOutlet var 날짜: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var 총볼륨: UILabel!
    @IBOutlet var totalVolumeLabel: UILabel!
}
