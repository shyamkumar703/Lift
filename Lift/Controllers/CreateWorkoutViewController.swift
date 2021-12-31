//
//  CreateWorkoutViewController.swift
//  Lift
//
//  Created by Shyam Kumar on 12/27/21.
//

import UIKit

class CreateWorkoutViewController: UIViewController {
    
    var delegate: SaveDelegate?
    var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(
            NSAttributedString(
                string: "Save",
                attributes: [
                    .font: UIFont.regularFont.withSize(15),
                    .foregroundColor: UIColor.black
                ]
            ),
            for: .normal
        )
        button.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var workoutNameField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .regularFont.withSize(25)
        field.textColor = .black
        field.attributedPlaceholder = NSAttributedString(
            string: "Workout Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        return field
    }()
    
    lazy var colorSelector: ColorSelector = {
        let view = ColorSelector()
        view.model = ColorSelectorModel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = tableView
        return view
    }()
    
    lazy var tableView: WorkoutTableView = {
        var tv = WorkoutTableView()
        var model = WorkoutTableViewModel(
            exercises: [
                ExerciseModel(
                    sets: [
                        SetModel()
                    ]
                )
            ],
            inWorkout: false
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
    
    override func viewWillDisappear(_ animated: Bool) {
        willDisappear()
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(workoutNameField)
        view.addSubview(colorSelector)
        view.addSubview(tableView)
        view.addSubview(saveButton)
        setupHideKeyboardOnTap()
        self.delegate = tableView.model
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardNotification(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.origin.y ?? 0
        let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        
        if endFrameY >= UIScreen.main.bounds.size.height {
            keyboardHeightLayoutConstraint?.constant = 0
        } else {
            keyboardHeightLayoutConstraint?.constant = -1 * (endFrame?.size.height ?? 0)
        }
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    func setupConstraints() {
        
        saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        saveButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        workoutNameField.topAnchor.constraint(equalTo: saveButton.bottomAnchor).isActive = true
        workoutNameField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        workoutNameField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        colorSelector.topAnchor.constraint(equalTo: workoutNameField.bottomAnchor, constant: 8).isActive = true
        colorSelector.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        colorSelector.widthAnchor.constraint(equalToConstant: 88).isActive = true
        colorSelector.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        tableView.topAnchor.constraint(equalTo: colorSelector.bottomAnchor, constant: 28).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        keyboardHeightLayoutConstraint = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        keyboardHeightLayoutConstraint?.isActive = true
        
    }
    
    @objc func saveTapped() {
        if let workout = delegate?.toWorkout(),
           let title = workoutNameField.text {
            workout.title = title
            workout.color = colorSelector.color
            CRUD.saveObject(obj: workout, parentType: UserData.self)
        }
        feedback()
        dismiss(animated: true, completion: nil)
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
