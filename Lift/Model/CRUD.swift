//
//  CRUD.swift
//  Lift
//
//  Created by Shyam Kumar on 12/28/21.
//

import CoreData
import Foundation
import UIKit

fileprivate let entityName: String = "UserData"
fileprivate let workoutName: String = "workout"

class CRUD {
    
    private static func retrieveEntity(entityName: String = entityName) -> NSEntityDescription? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate  else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        return NSEntityDescription.entity(forEntityName: entityName, in: managedContext)
    }
    
    static func saveObject<T: NSManagedObject>(obj: NSObject, parentType: T.Type, key: String = workoutName) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate  else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        if let userEntity = retrieveEntity(),
           let userData = NSManagedObject(entity: userEntity, insertInto: managedContext) as? T {
            userData.setValue(obj, forKey: key)
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("\(error)")
            }
        }
    }
    
    private static func retrieveData<T: NSObject>(entityKey: String = entityName, elementKey: String = workoutName, returnType: T.Type) -> [T]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityKey)
        
        do {
            if let result = try managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                if let retArr = result.map({ $0.value(forKey: elementKey) as? T }).filter({ $0 != nil }) as? [T] {
                    return retArr
                }
            }
        } catch let error as NSError {
            print("\(error)")
        }
        
        return nil
    }
    
    private static func fetchAndMap<InternalObject: NSObject, MappedObject: Any>(mapping: (InternalObject) -> MappedObject?) -> [MappedObject] {
        if let workouts = retrieveData(returnType: InternalObject.self),
           let mapped = workouts.map({mapping($0)}).filter({$0 != nil}) as? [MappedObject] {
            return mapped
        }
        return []
    }
    
    static func fetchHistoryData() -> MinHistoryTableViewModel {
        func mapping(workout: Workout) -> MinHistoryTableViewCellModel? {
            if workout.completed {
                return workout.convertToHistory()
            }
            return nil
        }
        
        return MinHistoryTableViewModel(cells: fetchAndMap(mapping: mapping(workout:)))
    }
}
