//
//  MinHistoryTableView.swift
//  Lift
//
//  Created by Shyam Kumar on 12/26/21.
//

import UIKit

fileprivate var cellId: String = "workout"

struct MinHistoryTableViewCellModel {
    var color: UIColor
    var name: String
    var ipArr: [String]
    var workout: Workout
    
    init(
        color: UIColor = .liftTeal,
        name: String = "Pull",
        ipArr: [String] = ["22 JAN 2022", "1,418 lbs", "35 mins"],
        workout: Workout = Workout()
    ) {
        self.color = color
        self.name = name
        self.ipArr = ipArr
        self.workout = workout
    }
}

struct MinHistoryTableViewModel {
    var cells: [MinHistoryTableViewCellModel]
    
    init(cells: [MinHistoryTableViewCellModel] = []) {
        self.cells = cells
    }
}

class MinHistoryTableView: UIView {
    
    var model: MinHistoryTableViewModel = MinHistoryTableViewModel() {
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
        table.register(MinHistoryTableViewCell.self, forCellReuseIdentifier: cellId)
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
        tableView.reloadData()
    }
}

extension MinHistoryTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? MinHistoryTableViewCell {
            cell.model = model.cells[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}

class MinHistoryTableViewCell: UITableViewCell {
    
    let circleDim: CGFloat = 12
    
    var model = MinHistoryTableViewCellModel() {
        didSet {
            updateView()
        }
    }
    
    lazy var circleView: ColorCircle = {
        let view = ColorCircle()
        view.model.dim = circleDim
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(ipLabel)
        return stack
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .regularFont.withSize(16)
        label.textAlignment = .left
        return label
    }()
    
    lazy var ipLabel: IPLabel = {
        let view = IPLabel()
        return view
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
        addSubview(circleView)
        addSubview(stack)
    }
    
    func setupConstraints() {
        circleView.heightAnchor.constraint(equalToConstant: circleDim).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: circleDim).isActive = true
//        circleView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        circleView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        circleView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        
        stack.leftAnchor.constraint(equalTo: circleView.rightAnchor, constant: 20).isActive = true
        stack.topAnchor.constraint(equalTo: circleView.topAnchor, constant: -4).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        
    }
    
    func updateView() {
        circleView.model.color = model.color
        titleLabel.text = model.name
        ipLabel.model.stats = model.ipArr
    }
}
