//
//  WorkoutTableView.swift
//  Lift
//
//  Created by Shyam Kumar on 12/27/21.
//

import UIKit

fileprivate var headerId: String = "header"
fileprivate var cellId: String = "cell"

struct WorkoutTableViewModel {
    var exercises: [ExerciseModel]
    
    init(exercises: [ExerciseModel] = []) {
        self.exercises = exercises
    }
}

struct ExerciseModel {
    var title: String
    var sets: [SetModel]
    
    init(title: String = "", sets: [SetModel] = []) {
        self.title = title
        self.sets = sets
    }
}

struct SetModel {
    var setNumber: Int
    var goalReps: Int?
    var weight: Int?
    var inWorkout: Bool
    var completedReps: Int?
    var completedWeight: Int?
    
    init(
        setNumber: Int = 1,
        goalReps: Int? = nil,
        weight: Int? = nil,
        inWorkout: Bool = false,
        completedReps: Int? = nil,
        completedWeight: Int? = nil
    ) {
        self.setNumber = setNumber
        self.goalReps = goalReps
        self.weight = weight
        self.inWorkout = inWorkout
        self.completedReps = completedReps
        self.completedWeight = completedWeight
    }
}

class WorkoutTableView: UIView {
    
    var model: WorkoutTableViewModel = WorkoutTableViewModel() {
        didSet {
            updateView()
        }
    }
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.allowsSelection = false
        table.backgroundColor = .clear
        table.register(ExerciseHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        table.register(SetCell.self, forCellReuseIdentifier: cellId)
        table.tableFooterView = UIView()
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(tableView)
    }
    
    func setupConstraints() {
        constrain(view: tableView, to: self)
    }
    
    func updateView() {
        if let inWorkout = model.exercises.first?.sets.first?.inWorkout {
            if !inWorkout {
                tableView.separatorStyle = .none
            }
        }
        tableView.reloadData()
    }
}

extension WorkoutTableView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        model.exercises.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.exercises[section].sets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? SetCell {
            let cellModel = model.exercises[indexPath.section].sets[indexPath.row]
            cell.model = cellModel
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as? ExerciseHeader {
            header.backgroundView = UIView()
            header.backgroundView?.backgroundColor = .clear
            header.model.title = model.exercises[section].title
            header.tag = section
            return header
        }
        return nil
    }
}

struct ExerciseHeaderModel {
    var title: String
    
    init(title: String = "") {
        self.title = title
    }
}

class ExerciseHeader: UITableViewHeaderFooterView {
    
    var model: ExerciseHeaderModel = ExerciseHeaderModel() {
        didSet {
            updateView()
        }
    }
    
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(titleTextField)
        stack.addArrangedSubview(addSetButton)
        return stack
    }()
    
    lazy var titleTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Exercise"
        field.textColor = .black
        field.textAlignment = .left
        field.font = .regularFont.withSize(20)
        return field
    }()
    
    lazy var addSetButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(stack)
    }
    
    func setupConstraints() {
        stack.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
    
    func updateView() {
        titleTextField.text = model.title
    }
}

class SetCell: UITableViewCell, UITextFieldDelegate {
    
    var model: SetModel = SetModel() {
        didSet {
            updateView()
        }
    }
    
    lazy var outerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 8
        
        stack.addArrangedSubview(goalStack)
        return stack
    }()
    
    lazy var goalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        stack.addArrangedSubview(setsLabel)
        stack.addArrangedSubview(repsTextField)
        stack.addArrangedSubview(weightTextField)
        return stack
    }()
    
    lazy var completedStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        stack.addArrangedSubview(completedLabel)
        stack.addArrangedSubview(completedRepsTextField)
        stack.addArrangedSubview(completedWeightTextField)
        return stack
    }()
    
    // MARK: - GOAL VARIABLES
    lazy var setsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = .regularFont.withSize(15)
        return label
    }()
    
    lazy var repsTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Reps"
        field.font = .regularFont.withSize(15)
        field.keyboardType = .numberPad
        field.textColor = .black
        field.textAlignment = .center
        field.isUserInteractionEnabled = true
        field.tag = 1
        field.delegate = self
        return field
    }()
    
    lazy var weightTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Weight"
        field.font = .regularFont.withSize(15)
        field.textColor = .black
        field.keyboardType = .numberPad
        field.textAlignment = .right
        field.isUserInteractionEnabled = true
        field.tag = 2
        field.delegate = self
        return field
    }()
    
    // MARK: - COMPLETED VARIABLES
    lazy var completedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = .regularFont.withSize(15)
        label.text = "Completed"
        return label
    }()
    
    lazy var completedRepsTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Reps"
        field.font = .regularFont.withSize(15)
        field.keyboardType = .numberPad
        field.textColor = .black
        field.textAlignment = .center
        field.tag = 1
        field.delegate = self
        return field
    }()
    
    lazy var completedWeightTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Weight"
        field.font = .regularFont.withSize(15)
        field.textColor = .black
        field.keyboardType = .numberPad
        field.textAlignment = .right
        field.tag = 2
        field.delegate = self
        return field
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(outerStack)
    }
    
    func setupConstraints() {
        outerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        outerStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
        outerStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        outerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    }
    
    func updateView() {
        setsLabel.text = "Set \(model.setNumber)"
        if let reps = model.goalReps { repsTextField.text = "\(reps) reps" }
        if let weight = model.weight { weightTextField.text = "\(weight) lbs" }
        if model.inWorkout {
            outerStack.addArrangedSubview(completedStack)
            if let reps = model.completedReps { completedRepsTextField.text = "\(reps) reps" }
            if let weight = model.completedWeight { completedWeightTextField.text = "\(weight) lbs" }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let textType = textField.getTextType() {
            switch textType {
            case .reps:
                textField.text = textField.text?.replacingOccurrences(of: " reps", with: "")
            case .weight:
                textField.text = textField.text?.replacingOccurrences(of: " lbs", with: "")
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let textType = textField.getTextType(),
           let text = textField.text {
            if !text.isEmpty {
                switch textType {
                case .reps:
                    textField.text = "\(text) reps"
                case .weight:
                    textField.text = "\(text) lbs"
                }
            }
        }
    }
}


