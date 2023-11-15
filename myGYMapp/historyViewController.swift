//
//  historyViewController.swift
//  myGYMapp
//
//  Created by MAC on 10/24/23.
//

import UIKit
import CoreData

class historyViewController: UIViewController {
    
    var context: NSManagedObjectContext {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        return app.persistentContainer.viewContext
    }
    
    var savelist = [saveList]()
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.dataSource = self
        self.tableview.delegate = self
        ReadData()
        print("히스토리뷰컨트롤러에 savelist 갯수는 --> \(savelist.count)")
    }
    
    func typeChange(_ managedobject: NSManagedObject) -> saveList {
        let date = managedobject.value(forKey: "date") as? String ?? ""
        let totalVolume = managedobject.value(forKey: "totalVolume") as? String ?? ""
        return saveList(date: date, totalVolume: totalVolume)
    }
    
    func ReadData() {
        let request = NSFetchRequest<NSManagedObject>(entityName: "HistoryInfo")
        do {
            let data = try context.fetch(request)
            savelist = data.map{typeChange($0)}
            print("HistoryVC 에서 정상적으로 데이터를 Read 함. ")
            self.tableview.reloadData()
        } catch {
            print(error)
        }
    }
    
    func deleteData(_ list: saveList) {
        let request = NSFetchRequest<NSManagedObject>(entityName: "HistoryInfo")
        request.predicate = NSPredicate(format: "date == %@" , list.date)
        
        do {
            let results = try context.fetch(request)
            for historyinfo in results as! [HistoryInfo] {
                context.delete(historyinfo)
            }
            try context.save()
            print("코어데이터에서 삭제가 정상적으로 실행되었습니다.")
        } catch {
            
        }
        
        if let index = savelist.firstIndex(where: {$0.date == list.date}) {
            savelist.remove(at: index)
            tableview.reloadData()
        }
    }
    
}

extension historyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savelist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "histroyCell", for: indexPath) as? histroyCell else {
            return UITableViewCell()
        }
        let data = savelist[indexPath.row]
        cell.dateLabel.text = data.date
        cell.totalVolumeLabel.text = data.totalVolume
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let data = savelist[indexPath.row]
            deleteData(data)
        }
        print("셀이 지워졌다. 현재 남아있는 savelist 배열의 갯수는 --> \(savelist.count)")
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
