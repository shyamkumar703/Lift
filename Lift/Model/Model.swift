//
//  Model.swift
//  Lift
//
//  Created by Shyam Kumar on 12/28/21.
//

import Foundation
import UIKit

public class Workout: NSObject, NSCoding {
    var exercises: [Exercise]
    var title: String
    var completed: Bool
    var dateCompleted: Date?
    var color: UIColor
    var completedTime: Int?
    
    enum Key: String {
        case exercises = "exercises"
        case title = "title"
        case completed = "finished"
        case dateCompleted = "dateCompleted"
        case color = "color"
        case completedTime = "completedTime"
    }
    
    init(exercises: [Exercise] = [], title: String = "", completed: Bool = false, dateCompleted: Date? = nil, color: UIColor = .liftRed, completedTime: Int? = nil) {
        self.title = title
        self.exercises = exercises
        self.completed = completed
        self.dateCompleted = dateCompleted
        self.color = color
        self.completedTime = completedTime
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(title, forKey: Key.title.rawValue)
        coder.encode(exercises, forKey: Key.exercises.rawValue)
        coder.encode(completed, forKey: Key.completed.rawValue)
        coder.encode(dateCompleted, forKey: Key.dateCompleted.rawValue)
        coder.encode(color, forKey: Key.color.rawValue)
        coder.encode(completedTime, forKey: Key.completedTime.rawValue)
    }
    
    public required init?(coder: NSCoder) {
        self.title = (coder.decodeObject(forKey: Key.title.rawValue) as? String) ?? ""
        self.exercises = (coder.decodeObject(forKey: Key.exercises.rawValue) as? [Exercise]) ?? []
        self.completed = coder.decodeBool(forKey: Key.completed.rawValue)
        self.dateCompleted = coder.decodeObject(forKey: Key.dateCompleted.rawValue) as? Date
        self.color = (coder.decodeObject(forKey: Key.color.rawValue) as? UIColor) ?? .liftRed
        self.completedTime = coder.decodeObject(forKey: Key.completedTime.rawValue) as? Int
    }
    
    func convertToHistory() -> MinHistoryTableViewCellModel? {
        if let date = dateCompleted,
           let time = completedTime,
           let weight = (
                exercises.flatMap({
                    $0.sets.map({ set->Int? in
                        if let reps = set.completedReps,
                           let weight = set.completedWeight {
                            return reps * weight
                        }
                        return nil
                    }
                )}
                ).filter({ $0 != nil }) as? [Int])?.reduce(0, +) {
            let ipArr = [dateFormatter.string(from: date), (numberFormatter.string(from: NSNumber(value: weight)) ?? "") + " lbs", "\(time) mins"]
            return MinHistoryTableViewCellModel(color: color, name: title, ipArr: ipArr, workout: self)
        }
        return nil
    }
    
    func getWeight() -> Int? {
        return (exercises.flatMap({
            $0.sets.map({ set->Int? in
                if let reps = set.completedReps,
                   let weight = set.completedWeight {
                    return reps * weight
                }
                return nil
            })
        }).filter({$0 != nil}) as? [Int])?.reduce(0, +)
    }
    
    func convertToNative(inWorkout: Bool, isObserving: Bool) -> WorkoutTableViewModel {
        let nativeExercises = exercises.map({$0.convertToNative(inWorkout: inWorkout)})
        return WorkoutTableViewModel(exercises: nativeExercises, inWorkout: inWorkout, isObserving: isObserving)
    }
}

public class Exercise: NSObject, NSCoding {
    var title: String
    var sets: [WSet]
    
    enum Key: String {
        case title = "title"
        case sets = "sets"
    }
    
    init(title: String, sets: [WSet] = []) {
        self.title = title
        self.sets = sets
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(title, forKey: Key.title.rawValue)
        coder.encode(sets, forKey: Key.sets.rawValue)
    }
    
    public required init?(coder: NSCoder) {
        self.title = (coder.decodeObject(forKey: Key.title.rawValue) as? String) ?? ""
        self.sets = (coder.decodeObject(forKey: Key.sets.rawValue) as? [WSet]) ?? []
    }
    
    func convertToNative(inWorkout: Bool) -> ExerciseModel {
        let nativeSets = sets.map({$0.convertToNative(inWorkout: inWorkout)})
        return ExerciseModel(title: title, sets: nativeSets)
    }
}

public class WSet: NSObject, NSCoding {
    var setNumber: Int
    var goalReps: Int
    var weight: Int
    var completedReps: Int?
    var completedWeight: Int?
    
    enum Key: String {
        case setNumber = "setNumber"
        case goalReps = "goalReps"
        case weight = "weight"
        case completedReps = "completedReps"
        case completedWeight = "completedWeight"
    }
    
    public init(
        setNumber: Int,
        goalReps: Int,
        weight: Int,
        completedReps: Int? = nil,
        completedWeight: Int? = nil
    ) {
        self.setNumber = setNumber
        self.goalReps = goalReps
        self.weight = weight
        self.completedReps = completedReps
        self.completedWeight = completedWeight
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(setNumber, forKey: Key.setNumber.rawValue)
        coder.encode(goalReps, forKey: Key.goalReps.rawValue)
        coder.encode(weight, forKey: Key.weight.rawValue)
        coder.encode(completedReps, forKey: Key.completedReps.rawValue)
        coder.encode(completedWeight, forKey: Key.completedWeight.rawValue)
    }
    
    public required init?(coder: NSCoder) {
        self.setNumber = coder.decodeInteger(forKey: Key.setNumber.rawValue)
        self.goalReps = coder.decodeInteger(forKey: Key.goalReps.rawValue)
        self.weight = coder.decodeInteger(forKey: Key.weight.rawValue)
        self.completedReps = coder.decodeObject(forKey: Key.completedReps.rawValue) as? Int
        self.completedWeight = coder.decodeObject(forKey: Key.completedWeight.rawValue) as? Int
    }
    
    func convertToNative(inWorkout: Bool) -> SetModel {
        let model = SetModel(
            setNumber: setNumber,
            goalReps: goalReps,
            weight: weight,
            inWorkout: inWorkout,
            completedReps: completedReps,
            completedWeight: completedWeight
        )
        
//        if !inWorkout {
//            model.completedReps = completedReps
//            model.completedWeight = completedWeight
//        }
        
        return model
    }
}
