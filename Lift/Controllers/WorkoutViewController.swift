//
//  WorkoutViewController.swift
//  Lift
//
//  Created by Shyam Kumar on 12/30/21.
//

import UIKit

class WorkoutViewController: UIViewController {
    
    var delegate: SaveDelegate?
    var workout: Workout? {
        didSet {
            updateView()
        }
    }
    
    let circleDim: CGFloat = 16
    let dateStarted = Date()
    var timer: Timer?
    var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    let titleAttrs: [NSAttributedString.Key: Any] = [
        .font: UIFont.regularFont.withSize(20),
        .foregroundColor: UIColor.black
    ]
    
    let timeAttrs: [NSAttributedString.Key: Any] = [
        .font: UIFont.regularFont.withSize(12),
        .foregroundColor: UIColor.gray
    ]
    
    lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(
            NSAttributedString(
                string: "Done",
                attributes: [
                    .font: UIFont.regularFont.withSize(15),
                    .foregroundColor: UIColor.black
                ]
            ),
            for: .normal
        )
        button.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var circle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = circleDim / 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    lazy var tableView: WorkoutTableView = {
        let tv = WorkoutTableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        willDisappear()
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(doneButton)
        view.addSubview(circle)
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        setupHideKeyboardOnTap()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        delegate = tableView.model
        
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
        doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        circle.heightAnchor.constraint(equalToConstant: circleDim).isActive = true
        circle.widthAnchor.constraint(equalToConstant: circleDim).isActive = true
        circle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        circle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48).isActive = true
        
        titleLabel.centerYAnchor.constraint(equalTo: circle.centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: circle.rightAnchor, constant: 12).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        tableView.topAnchor.constraint(equalTo: circle.bottomAnchor, constant: 28).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        keyboardHeightLayoutConstraint = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        keyboardHeightLayoutConstraint?.isActive = true
    }
    
    func updateView() {
        if let workout = workout {
            circle.backgroundColor = workout.color
            tableView.model = workout.convertToNative(inWorkout: true)
            tableView.selectionChanged(color: workout.color)
            
            titleLabel.attributedText = constructAttributedString(
                str1: "\(workout.title) ",
                attr1: titleAttrs,
                str2: dateStarted.timeElapsed(toDate: Date()),
                attr2: timeAttrs
            )
        }
    }
    
    @objc func updateTime() {
        if let workout = workout {
            titleLabel.attributedText = constructAttributedString(
                str1: "\(workout.title) ",
                attr1: titleAttrs,
                str2: dateStarted.timeElapsed(toDate: Date()),
                attr2: timeAttrs
            )
        }
    }
    
    @objc func doneTapped() {
        if let workout = delegate?.toWorkout(),
           let passedWO = self.workout {
            workout.color = passedWO.color
            workout.title = passedWO.title
            workout.completed = true
            workout.dateCompleted = Date()
            workout.completedTime = Int((Date() - dateStarted) / 60)
            CRUD.saveObject(obj: workout, parentType: UserData.self)
        }
        dismiss(animated: true, completion: nil)
    }
}
