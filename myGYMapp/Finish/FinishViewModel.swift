//
//  FinishViewModel.swift
//  myGYMapp
//
//  Created by MAC on 12/2/23.
//

import Foundation
import UIKit
import CoreData

class FinishViewModel {
    
    var context: NSManagedObjectContext {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        return app.persistentContainer.viewContext
    }
    
    var savelist = [saveList]()
    
    func appendSaveList(todaytotal: String , date: String) {
        let data = saveList(date: date, totalVolume: todaytotal)
        self.savelist.append(data)
    }
   
    func saveCoreData(date: String , totalVolume: String) {
        
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: "HistoryInfo", into: context)
        newEntity.setValue(date, forKey: "date")
        newEntity.setValue(totalVolume, forKey: "totalVolume")
        
        if context.hasChanges {
            do {
                try context.save()
                print("코어데이터에 정상적으로 저장되었습니다")
            } catch {
                print("코어데이터저장실패 \(error)")
            }
        }
    }
}
