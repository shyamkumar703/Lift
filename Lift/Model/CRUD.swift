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
    
    static func retrieveData<T: NSObject>(entityKey: String = entityName, elementKey: String = workoutName, returnType: T.Type) -> [T]? {
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
    
    private static func fetchAndMap<InternalObject: NSObject, MappedObject: Any>(mapping: (InternalObject) -> MappedObject?, sort: ([InternalObject]?) -> [InternalObject]?) -> [MappedObject] {
        if let workouts = sort(retrieveData(returnType: InternalObject.self)),
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
        
        func sort(arr: [Workout]?) -> [Workout]? {
            if let arr = arr {
                return arr.sorted(by: { w1, w2 in
                    if let d1 = w1.dateCompleted,
                       let d2 = w2.dateCompleted {
                        return d1 > d2
                    }
                    return true
                })
            }
            return nil
        }
        
        return MinHistoryTableViewModel(cells: fetchAndMap(mapping: mapping(workout:), sort: sort(arr:)))
    }
    
    static func fetchTrendsData() -> MinTrendsTableViewModel {
        if let workouts = retrieveData(returnType: Workout.self) {
            let uniqueWorkouts = fetchUniqueWorkouts()
            let pairCellArr = uniqueWorkouts.map({ uw -> (Workout, [Workout]) in
                let filteredWorkouts = workouts.filter({$0.title == uw.title && $0.completed}).sorted(by: { w1, w2 in
                    if let date1 = w1.dateCompleted,
                       let date2 = w2.dateCompleted {
                        return date1 < date2
                    }
                    return true
                })
                return (uw, filteredWorkouts)
            })
            
            var cells: [MinTrendsTableViewCellModel] = []
            
            for pair in pairCellArr {
                if pair.1.count < 2 {
                    continue
                }
                
                if let lastWorkout = pair.1.last {
                    let secondToLast = pair.1[pair.1.count - 2]
                    var progressString = ((lastWorkout.getWeight() ?? 0) - (secondToLast.getWeight() ?? 0) < 0) ? "" : "+"
                    progressString += "\((lastWorkout.getWeight() ?? 0) - (secondToLast.getWeight() ?? 0)) lbs"
                    let ipArr = [
                        dateFormatter.string(from: lastWorkout.dateCompleted ?? Date()),
                        "\(lastWorkout.completedTime ?? 0) mins",
                        progressString
                    ]
                    cells.append(MinTrendsTableViewCellModel(color: pair.0.color, title: pair.0.title, ipArr: ipArr, weightArr: pair.1.map({$0.getWeight() ?? 0}), workouts: pair.1))
                }
            }
            return MinTrendsTableViewModel(cells: cells)
        }
        
        return MinTrendsTableViewModel()
    }
    
    static func fetchWorkoutsData() -> MinHistoryTableViewModel {
        return MinHistoryTableViewModel(
            cells: fetchUniqueWorkouts().map(
                { workout in
                    MinHistoryTableViewCellModel(
                        color: workout.color,
                        name: workout.title,
                        ipArr: workout.exercises.map({$0.title}),
                        workout: workout
                    )
                }
            )
        )
    }
}

extension CRUD {
    private static func fetchUniqueWorkouts() -> [Workout] {
        if let workouts = retrieveData(returnType: Workout.self) {
            var seen: [Workout] = []
            _ = workouts.map({ workout in
                if seen.filter({$0.title == workout.title}).count == 0 {
                    seen.append(workout)
                }
            })
            return seen
        }
        return []
    }
}
