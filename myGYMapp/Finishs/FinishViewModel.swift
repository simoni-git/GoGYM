//
//  FisishViewModel.swift
//  myGYMapp
//
//  Created by 시모니 on 12/9/23.
//

import UIKit
import CoreData

class FinishViewModel {
    
    static let shared = FinishViewModel()
    private init() {}
    
    var context: NSManagedObjectContext {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        return app.persistentContainer.viewContext
    }
    
    var savelist = [saveList]()
    
    var chestTotalvolume: Double? = 0.0
    var backTotalVolume: Double? = 0.0
    var legTotalVolume: Double? = 0.0
    var shoulderTotalVolume: Double? = 0.0
    var armTotalVolume: Double? = 0.0
    
    func appendSaveList(todaytotal: String , date: String) {
        let data = saveList(date: date, totalVolume: todaytotal)
        self.savelist.append(data)
    }
    
    func savedata(date: String , totalVolume: String) {
        let data = saveList(date: date, totalVolume: totalVolume)
        self.savelist.append(data)
        
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
