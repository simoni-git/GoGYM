//
//  HistoryViewModel.swift
//  myGYMapp
//
//  Created by MAC on 12/2/23.
//

import Foundation
import UIKit
import CoreData

class HistoryViewModel {
    
    var savelist = [saveList]()
    
    var context: NSManagedObjectContext {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        return app.persistentContainer.viewContext
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
        } catch {
            print("HistoryVC 에서 데이터를 Read 실패")
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
            print("코어데이터에서 삭제가 실패했습니다")
        }
        
        if let index = savelist.firstIndex(where: {$0.date == list.date}) {
            savelist.remove(at: index)
        }
    }
}
