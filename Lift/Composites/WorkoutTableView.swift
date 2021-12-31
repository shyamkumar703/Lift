//
//  WorkoutTableView.swift
//  Lift
//
//  Created by Shyam Kumar on 12/27/21.
//

import UIKit

fileprivate var headerId: String = "header"
fileprivate var cellId: String = "cell"

protocol SaveDelegate {
    func toWorkout() -> Workout?
}

class WorkoutTableViewModel: SaveDelegate {
    var exercises: [ExerciseModel]
    var inWorkout: Bool
    var isObserving: Bool
    
    init(exercises: [ExerciseModel] = [], inWorkout: Bool = false, isObserving: Bool = false) {
        self.exercises = exercises
        self.inWorkout = inWorkout
        self.isObserving = isObserving
    }
    
    func toWorkout() -> Workout? {
        if let exercises = exercises.map({ $0.toExercise() }).filter({ $0 != nil }) as? [Exercise] {
            if exercises.count == 0 { return nil }
            return Workout(exercises: exercises)
        }
        return nil
    }
}

class ExerciseModel {
    var title: String
    var sets: [SetModel]
    var isObserving: Bool
    
    init(title: String = "", sets: [SetModel] = [], isObserving: Bool = false) {
        self.title = title
        self.sets = sets
        self.isObserving = isObserving
    }
    
    func toExercise() -> Exercise? {
        if let sets = sets.map({ $0.toWSet() }).filter({ $0 != nil }) as? [WSet] {
            if sets.count == 0 { return nil }
            return Exercise(title: title, sets: sets)
        }
        return nil
    }
}

class SetModel {
    var setNumber: Int
    var goalReps: Int?
    var weight: Int?
    var inWorkout: Bool
    var completedReps: Int?
    var completedWeight: Int?
    var isObserving: Bool
    
    init(
        setNumber: Int = 1,
        goalReps: Int? = nil,
        weight: Int? = nil,
        inWorkout: Bool = false,
        completedReps: Int? = nil,
        completedWeight: Int? = nil,
        isObserving: Bool = false
    ) {
        self.setNumber = setNumber
        self.goalReps = goalReps
        self.weight = weight
        self.inWorkout = inWorkout
        self.completedReps = completedReps
        self.completedWeight = completedWeight
        self.isObserving = isObserving
    }
    
    func toWSet() -> WSet? {
        if let goalReps = goalReps,
           let weight = weight {
            return WSet(
                setNumber: setNumber,
                goalReps: goalReps,
                weight: weight,
                completedReps: completedReps,
                completedWeight: completedWeight
            )
        }
        return nil
    }
}

class WorkoutTableView: UIView {
    
    var model: WorkoutTableViewModel = WorkoutTableViewModel() {
        didSet {
            updateView()
        }
    }
    
    var isEditable: Bool = true {
        didSet {
            tableView.isUserInteractionEnabled = isEditable
        }
    }
    
    lazy var footer: WorkoutTableFooter = {
        let footer = WorkoutTableFooter()
        footer.frame = CGRect(x: 0, y: 0, width: 0, height: 100)
        footer.delegate = self
        footer.isUserInteractionEnabled = true
        return footer
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.allowsSelection = false
        table.backgroundColor = .clear
        table.register(ExerciseHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        table.register(SetCell.self, forCellReuseIdentifier: cellId)
        table.isUserInteractionEnabled = isEditable
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
    
    override func layoutSubviews() {
        if model.isObserving {
            let view = UIView()
            view.backgroundColor = .white
            tableView.tableFooterView = view
        } else {
            tableView.tableFooterView = footer
        }
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

extension WorkoutTableView: UITableViewDelegate, UITableViewDataSource, HeaderDelegate, WorkoutTableFooterDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        model.exercises.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.exercises[section].sets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? SetCell {
            let cellModel = model.exercises[indexPath.section].sets[indexPath.row]
            cellModel.isObserving = model.isObserving
            cell.model = cellModel
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as? ExerciseHeader {
            header.backgroundView = UIView()
            header.backgroundView?.backgroundColor = .white
            model.exercises[section].isObserving = model.isObserving
            header.model = model.exercises[section]
            header.tag = section
            header.delegate = self
            return header
        }
        return nil
    }
    
    func addSet(to section: Int) {
        model.exercises[section].sets.append(SetModel(setNumber: model.exercises[section].sets.count + 1, inWorkout: model.inWorkout))
        let indexPath = IndexPath(row: model.exercises[section].sets.count - 1, section: section)
        tableView.insertRows(at: [indexPath], with: .fade)
    }
    
    func addExercise() {
        model.exercises.append(ExerciseModel(sets: [SetModel(inWorkout: model.inWorkout)]))
        tableView.insertSections(IndexSet(integer: model.exercises.count - 1), with: .fade)
    }
}

extension WorkoutTableView: ColorSelectorDelegate {
    func selectionChanged(color: UIColor?) {
        if let color = color {
            footer.animateColorChange(newColor: color)
        }
    }
}

protocol HeaderDelegate {
    func addSet(to section: Int)
}

class ExerciseHeader: UITableViewHeaderFooterView, UITextFieldDelegate {
    
    var model: ExerciseModel = ExerciseModel() {
        didSet {
            updateView()
        }
    }
    
    var delegate: HeaderDelegate?
    
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
        field.font = .regularFont.withSize(15)
        field.delegate = self
        field.attributedPlaceholder = NSAttributedString(
            string: "Exercise",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        return field
    }()
    
    lazy var addSetButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(addSetTapped), for: .touchUpInside)
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
        backgroundColor = .clear
    }
    
    func setupConstraints() {
        stack.topAnchor.constraint(equalTo: topAnchor, constant: 24).isActive = true
        stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
    
    func updateView() {
        titleTextField.text = model.title
        titleTextField.isUserInteractionEnabled = !model.isObserving
        addSetButton.isHidden = model.isObserving
    }
    
    @objc func addSetTapped() {
        feedback()
        delegate?.addSet(to: tag)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            model.title = text
        }
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
        label.font = .regularFont.withSize(13)
        return label
    }()
    
    lazy var repsTextField: UITextField = {
        let field = UITextField()
        field.attributedPlaceholder = NSAttributedString(
            string: "Reps",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        field.font = .regularFont.withSize(13)
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
        field.attributedPlaceholder = NSAttributedString(
            string: "Weight",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        field.font = .regularFont.withSize(13)
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
        label.font = .regularFont.withSize(13)
        label.text = "Completed"
        return label
    }()
    
    lazy var completedRepsTextField: UITextField = {
        let field = UITextField()
        field.attributedPlaceholder = NSAttributedString(
            string: "Reps",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        field.font = .regularFont.withSize(13)
        field.keyboardType = .numberPad
        field.textColor = .black
        field.textAlignment = .center
        field.tag = 3
        field.delegate = self
        return field
    }()
    
    lazy var completedWeightTextField: UITextField = {
        let field = UITextField()
        field.attributedPlaceholder = NSAttributedString(
            string: "Weight",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        field.font = .regularFont.withSize(13)
        field.textColor = .black
        field.keyboardType = .numberPad
        field.textAlignment = .right
        field.tag = 4
        field.delegate = self
        return field
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    override func prepareForReuse() {
        repsTextField.text = ""
        weightTextField.text = ""
        completedRepsTextField.text = ""
        completedWeightTextField.text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(outerStack)
        backgroundColor = .clear
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
        repsTextField.isUserInteractionEnabled = !model.isObserving
        weightTextField.isUserInteractionEnabled = !model.isObserving
        completedRepsTextField.isUserInteractionEnabled = !model.isObserving
        completedWeightTextField.isUserInteractionEnabled = !model.isObserving
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let textType = textField.getTextType() {
            switch textType {
            case .reps, .completedReps:
                textField.text = textField.text?.replacingOccurrences(of: " reps", with: "")
            case .weight, .completedWeight:
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
                    model.goalReps = Int(text)
                case .weight:
                    textField.text = "\(text) lbs"
                    model.weight = Int(text)
                case .completedReps:
                    textField.text = "\(text) reps"
                    model.completedReps = Int(text)
                case .completedWeight:
                    textField.text = "\(text) lbs"
                    model.completedWeight = Int(text)
                }
            }
        }
    }
}

protocol WorkoutTableFooterDelegate {
    func addExercise()
}

class WorkoutTableFooter: UIView {
    
    var delegate: WorkoutTableFooterDelegate?
    
    lazy var addExerciseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .liftRed
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.widthAnchor.constraint(equalToConstant: 32).isActive = true
        button.layer.cornerRadius = 16
        button.tintColor = .white
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
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
        addSubview(addExerciseButton)
    }
    
    func setupConstraints() {
        addExerciseButton.topAnchor.constraint(equalTo: topAnchor, constant: 32).isActive = true
        addExerciseButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func animateColorChange(newColor: UIColor) {
        UIView.animate(withDuration: 0.3, animations: {
            self.addExerciseButton.backgroundColor = newColor
        })
    }
    
    @objc func buttonTapped() {
        feedback()
        delegate?.addExercise()
    }
}


