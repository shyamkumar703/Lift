//
//  LiftTests.swift
//  LiftTests
//
//  Created by Shyam Kumar on 12/24/21.
//

import XCTest
@testable import Lift

class LiftTests: XCTestCase {
    
    let testWorkout = Workout(
        exercises: [
            Exercise(
                title: "Bench Press",
                sets: [
                    WSet(
                        setNumber: 1,
                        goalReps: 5,
                        weight: 135,
                        completedReps: 5,
                        completedWeight: 135
                    )
                ]
            )
        ],
        title: "Test Workout 1",
        completed: true,
        dateCompleted: Date(),
        color: .liftTeal,
        completedTime: 35
    )
    
    func testCRUDSimple() {
        CRUD.saveObject(obj: testWorkout, parentType: UserData.self)
        if let workouts = CRUD.retrieveData(returnType: Workout.self),
           let compWorkout = workouts.last {
            compare(workout: testWorkout, toWorkout: compWorkout)
        }
    }
    
    func testConvertToHistory() {
        if let workouts = CRUD.retrieveData(returnType: Workout.self) {
            if workouts.filter({$0.completed == true}).count == 0 {
                CRUD.saveObject(obj: testWorkout, parentType: UserData.self)
                testConvertToHistory()
            } else {
                if let historyModel = CRUD.fetchHistoryData().cells.first {
                    compare(workout: testWorkout, toHistoryCell: historyModel)
                } else {
                    XCTFail("Did not find converted cell")
                }
            }
        }
    }
}

extension LiftTests {
    func compare(workout: Workout, toHistoryCell: MinHistoryTableViewCellModel) {
        XCTAssertEqual(workout.color, toHistoryCell.color)
        XCTAssertEqual(workout.title, toHistoryCell.name)
    }
    
    func compare(workout: Workout, toWorkout: Workout) {
        XCTAssertEqual(workout.title, toWorkout.title)
        XCTAssertEqual(workout.completed, toWorkout.completed)
        XCTAssertEqual(workout.color, toWorkout.color)
        XCTAssertEqual(workout.completedTime, toWorkout.completedTime)
    }
    
    func compare(exercise: Exercise, toExercise: Exercise) {
        XCTAssertEqual(exercise.title, toExercise.title)
        for (set, toSet) in zip(exercise.sets, toExercise.sets) {
            compare(set: set, toSet: toSet)
        }
    }
    
    func compare(set: WSet, toSet: WSet) {
        XCTAssertEqual(set.setNumber, toSet.setNumber)
        XCTAssertEqual(set.goalReps, toSet.goalReps)
        XCTAssertEqual(set.weight, toSet.weight)
        XCTAssertEqual(set.completedReps, toSet.completedReps)
        XCTAssertEqual(set.completedWeight, toSet.completedWeight)
    }
}
