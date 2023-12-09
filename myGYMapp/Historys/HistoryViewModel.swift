//
//  HistoryViewModel.swift
//  myGYMapp
//
//  Created by 시모니 on 12/9/23.
//

import UIKit
import CoreData

class HistoryViewModel {
    
    var context: NSManagedObjectContext {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        return app.persistentContainer.viewContext
    }
    
    var savelist = [saveList]()
    
    func typeChange(_ managedobject: NSManagedObject) -> saveList {
        let date = managedobject.value(forKey: "date") as? String ?? ""
        let totalVolume = managedobject.value(forKey: "totalVolume") as? String ?? ""
        return saveList(date: date, totalVolume: totalVolume)
    }
    
    func readData() {
        let request = NSFetchRequest<NSManagedObject>(entityName: "HistoryInfo")
        do {
            let data = try context.fetch(request)
            savelist = data.map{typeChange($0)}
            print("HistoryVC 에서 정상적으로 데이터를 Read 함. ")
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
        }
    }
    
}
