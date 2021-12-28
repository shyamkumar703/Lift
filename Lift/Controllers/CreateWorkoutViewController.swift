//
//  CreateWorkoutViewController.swift
//  Lift
//
//  Created by Shyam Kumar on 12/27/21.
//

import UIKit

class CreateWorkoutViewController: UIViewController {
    
    // height of color selector must be 24
    
    lazy var workoutNameField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .regularFont.withSize(25)
        field.textColor = .black
        field.placeholder = "Workout Name"
        return field
    }()
    
    lazy var colorSelector: ColorSelector = {
        let view = ColorSelector()
        view.model = ColorSelectorModel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    lazy var tableView: WorkoutTableView = {
        var tv = WorkoutTableView()
        var model = WorkoutTableViewModel(
            exercises: [
                ExerciseModel(
                    sets: [
                        SetModel(setNumber: 1, goalReps: 5, weight: 135, inWorkout: true, completedReps: nil, completedWeight: nil)
                    ]
                )
            ]
        )
        tv.model = model
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        workoutNameField.becomeFirstResponder()
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(workoutNameField)
        view.addSubview(colorSelector)
        view.addSubview(tableView)
        setupHideKeyboardOnTap()
    }
    
    func setupConstraints() {
        workoutNameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        workoutNameField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        workoutNameField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        colorSelector.topAnchor.constraint(equalTo: workoutNameField.bottomAnchor, constant: 8).isActive = true
        colorSelector.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        colorSelector.widthAnchor.constraint(equalToConstant: 88).isActive = true
        colorSelector.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        tableView.topAnchor.constraint(equalTo: colorSelector.bottomAnchor, constant: 28).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
}

extension CreateWorkoutViewController: ColorSelectorDelegate {
    func selectionChanged(color: UIColor?) {
    }
}

extension UIViewController {
    /// Call this once to dismiss open keyboards by tapping anywhere in the view controller
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }

    /// Dismisses the keyboard from self.view
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}
