//
//  CoreDataStorage.swift
//  Weather App
//
//  Created by Егор Пашкевич on 08.11.2021.
//

import Foundation
import CoreData
import UIKit

protocol CoreDataStorageProtocol {}

class CoreDataStorage: CoreDataStorageProtocol {

static var storage: TownsStorageProtocol = TownsStorage.shared
   
    static func delete(_ id: Int) {
        
        let appDelegeta = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegeta.persistentContainer.viewContext
        let fetch: NSFetchRequest<TownsID> = TownsID.fetchRequest()
        let predicate = NSPredicate.init(format: "id == %@", String(id))
        fetch.predicate = predicate
        if let result = try? context.fetch(fetch) {
            for object in result {
                context.delete(object)
            }
            do {
                try context.save()
            } catch {
           
            }
        }
        
    }
    
    
    
    
        static func clearAll() {
            
            let appDelegeta = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegeta.persistentContainer.viewContext
            let fetch: NSFetchRequest<TownsID> = TownsID.fetchRequest()
           
            if let result = try? context.fetch(fetch) {
                for object in result {
                    context.delete(object)
                }
                do {
                    try context.save()
                } catch {
               
                }
            }
            
        }
        
        
        
static func save() {
      
    let appDelegeta = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegeta.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "TownsID", in: context)
//    let storageToSave = Set(storage.allTowns.map({$0.id}))
    let storageToSave = storage.allTowns.map({($0.id, $0.town)})

    for (id, name) in storageToSave {
    let newTownToSave = NSManagedObject(entity: entity!, insertInto: context) as! TownsID
    newTownToSave.id = String(id)
    newTownToSave.name = name
        
            
        }
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    
    static func load() -> [String: String]? {
        var result: [String: String] = [:]
    let appDelegeta = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegeta.persistentContainer.viewContext
        let fetch: NSFetchRequest<TownsID> = TownsID.fetchRequest()
        var loadTowns: [TownsID] = []
        do {
            loadTowns = try context.fetch(fetch)
        } catch {
    print(error.localizedDescription)
}
        if loadTowns.count > 0 {
            
            for oneTown in loadTowns {
                result.updateValue(oneTown.name!, forKey: oneTown.id!)
            }
            
            return result
        }
    return nil
    }
}
