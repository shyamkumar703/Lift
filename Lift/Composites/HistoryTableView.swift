//
//  HistoryTableView.swift
//  Lift
//
//  Created by Shyam Kumar on 12/24/21.
//

import Foundation
import UIKit

fileprivate var cellId: String = "cell"
fileprivate var headerId: String = "header"

class HistoryTableView: UIView {
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(HistoryTableViewCell.self, forCellReuseIdentifier: cellId)
        table.register(HistoryTableViewHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.allowsSelection = false
        table.backgroundColor = .backgroundGray
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
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func updateView() {
    }
}

extension HistoryTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? HistoryTableViewCell {
            return cell
        }
        return UITableViewCell()
    }
}

class HistoryTableViewCell: UITableViewCell {
    
    lazy var outerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var outerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 20
        stack.addArrangedSubview(barView)
        stack.addArrangedSubview(statsView)
        return stack
    }()
    
    lazy var barView: BarView = {
        let bar = BarView()
        let color: UIColor = [UIColor.liftRed, UIColor.liftTeal, UIColor.liftPurple].randomElement()!
        let model = BarViewModel(segOneTitle: "Push", segOneSub: "PPL", segTwoTitle: "1,400", segTwoSub: "lbs", segThreeTitle: "5", segThreeSub: "exercises", segOneColor: color)
        bar.model = model
        bar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return bar
    }()
    
    lazy var statsView: StatsView = {
        let stat = StatsView()
        stat.translatesAutoresizingMaskIntoConstraints = false
        let model = StatsViewModel(segOneTitle: "22", segOneSub: "JAN\n2022", segTwoTitle: "35", segTwoSub: "\nMINS", segThreeTitle: "+5", segThreeSub: "\nLBS")
        stat.model = model
        stat.heightAnchor.constraint(equalToConstant: 36).isActive = true
        return stat
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
        backgroundColor = .backgroundGray
        outerView.addSubview(outerStack)
        addSubview(outerView)
    }
    
    func setupConstraints() {
        outerView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        outerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        outerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        outerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        outerStack.topAnchor.constraint(equalTo: outerView.topAnchor, constant: 12).isActive = true
        outerStack.leftAnchor.constraint(equalTo: outerView.leftAnchor, constant: 16).isActive = true
        outerStack.bottomAnchor.constraint(equalTo: outerView.bottomAnchor, constant: -12).isActive = true
        outerStack.rightAnchor.constraint(equalTo: outerView.rightAnchor, constant: -16).isActive = true
    }
}

class HistoryTableViewHeader: UITableViewHeaderFooterView {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Workout Feed"
        label.textAlignment = .left
        label.textColor = .black
        label.font = .regularFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        addSubview(label)
    }
    
    func setupConstraints() {
        label.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
}
