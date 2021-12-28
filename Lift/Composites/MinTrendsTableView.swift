//
//  MinTrendsTableView.swift
//  Lift
//
//  Created by Shyam Kumar on 12/27/21.
//

import UIKit

fileprivate var cellId: String = "trend"

struct MinTrendsTableViewModel {
    var cells: [MinTrendsTableViewCellModel]
    
    init(cells: [MinTrendsTableViewCellModel] = []) {
        self.cells = cells
    }
}

struct MinTrendsTableViewCellModel {
    var color: UIColor
    var title: String
    var ipArr: [String]
    var weightArr: [(Int, Int)]
    
    init(color: UIColor = .liftRed, title: String = "", ipArr: [String] = [], weightArr: [Int] = []) {
        self.color = color
        self.title = title
        self.ipArr = ipArr
        self.weightArr = []
        for i in 0..<weightArr.count {
            self.weightArr.append((i, weightArr[i]))
        }
    }
}

class MinTrendsTableView: UIView {
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(MinTrendsTableViewCell.self, forCellReuseIdentifier: cellId)
        table.allowsSelection = false
        table.backgroundColor = .clear
        table.tableFooterView = UIView()
        return table
    }()
    
    var model: MinTrendsTableViewModel = MinTrendsTableViewModel() {
        didSet {
            updateView()
        }
    }
    
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

extension MinTrendsTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MinTrendsTableViewCell {
            cell.model = model.cells[indexPath.row]
            cell.addPan()
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
}

class MinTrendsTableViewCell: UITableViewCell {
    
    var circleDim: CGFloat = 16
    
    lazy var circleView: ColorCircle = {
        let view = ColorCircle()
        view.model.dim = circleDim
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleStack: UIStackView = {
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
    
    lazy var weightGraphStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(weightLabel)
        stack.addArrangedSubview(graph)
        return stack
    }()
    
    lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    lazy var graph: LineChart = {
        let chart = LineChart()
        chart.heightAnchor.constraint(equalToConstant: 32).isActive = true
        return chart
    }()
    
    var model: MinTrendsTableViewCellModel = MinTrendsTableViewCellModel() {
        didSet {
            updateView()
        }
    }
    
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
        addSubview(titleStack)
        addSubview(weightGraphStack)
    }
    
    func setupConstraints() {
        circleView.heightAnchor.constraint(equalToConstant: circleDim).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: circleDim).isActive = true
        circleView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        circleView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        
        titleStack.leftAnchor.constraint(equalTo: circleView.rightAnchor, constant: 20).isActive = true
        titleStack.topAnchor.constraint(equalTo: circleView.topAnchor, constant: -4).isActive = true
        titleStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        
        weightGraphStack.topAnchor.constraint(equalTo: titleStack.bottomAnchor, constant: 4).isActive = true
        weightGraphStack.leftAnchor.constraint(equalTo: titleStack.leftAnchor, constant: 16).isActive = true
        weightGraphStack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        weightGraphStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
    }
    
    func updateView() {
        circleView.model.color = model.color
        titleLabel.text = model.title
        ipLabel.model.stats = model.ipArr
        weightLabel.attributedText = weightToString(int: model.weightArr.last?.1)
        graph.dataPoints = model.weightArr
        graph.lineColor = model.color
    }
    
    func weightToString(int: Int?) -> NSMutableAttributedString {
        if let int = int {
            let titleAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.regularFont.withSize(20),
                .foregroundColor: UIColor.black
            ]
            let subAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.regularFont.withSize(12),
                .foregroundColor: UIColor.black
            ]
            return constructAttributedString(str1: String(int), attr1: titleAttrs, str2: "lbs", attr2: subAttrs)
        }
        
        return NSMutableAttributedString()
    }
    
    func addPan() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        self.addGestureRecognizer(panGesture)
        panGesture.delegate = self
    }
    
    @objc func pan(_ gr: UIPanGestureRecognizer) {
        graph.panGesture(gr)
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
