//
//  TrendTableView.swift
//  Lift
//
//  Created by Shyam Kumar on 12/25/21.
//

import Foundation
import UIKit

fileprivate var cellId: String = "trend"

class TrendsTableView: UIView {
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(TrendsTableViewCell.self, forCellReuseIdentifier: cellId)
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.allowsSelection = false
        table.backgroundColor = .backgroundGray
        table.isUserInteractionEnabled = true
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
        tableView.backgroundColor = .backgroundGray
        addSubview(tableView)
    }
    
    func setupConstraints() {
        constrain(view: tableView, to: self)
    }
}

extension TrendsTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? TrendsTableViewCell {
            cell.addPan()
            return cell
        }
        
        return UITableViewCell()
    }
}

class TrendsTableViewCell: UITableViewCell {
    
    lazy var outerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
    }()
    
    lazy var bookmarkView: BookmarkLabel = {
        let view = BookmarkLabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        let model = BookmarkLabelModel(title: "Pull", sub: "PPL", color: [UIColor.liftTeal, UIColor.liftRed, UIColor.liftPurple].randomElement()!)
        view.model = model
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
        let titleAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.regularFont.withSize(20),
            .foregroundColor: UIColor.black
        ]
        let subAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.regularFont.withSize(12),
            .foregroundColor: UIColor.black
        ]
        label.attributedText = constructAttributedString(str1: "1,418", attr1: titleAttrs, str2: "lbs", attr2: subAttrs)
        label.textAlignment = .center
        return label
    }()
    
    lazy var graph: LineChart = {
        let chart = LineChart()
        chart.heightAnchor.constraint(equalToConstant: 50).isActive = true
        chart.lineColor = bookmarkView.model.color
        return chart
    }()
    
    lazy var statsView: StatsView = {
        let view = StatsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let model = StatsViewModel(segOneTitle: "22", segOneSub: "JAN\n2022", segTwoTitle: "35", segTwoSub: "\nMINS", segThreeTitle: "+5", segThreeSub: "\nLBS")
        view.model = model
        view.heightAnchor.constraint(equalToConstant: 36).isActive = true
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
        backgroundColor = .clear
        addSubview(outerView)
        outerView.addSubview(bookmarkView)
        outerView.addSubview(weightGraphStack)
        outerView.addSubview(statsView)
    }
    
    func setupConstraints() {
        // outer view
        outerView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        outerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        outerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        outerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        // bookmark view
        bookmarkView.topAnchor.constraint(equalTo: outerView.topAnchor).isActive = true
        bookmarkView.leftAnchor.constraint(equalTo: outerView.leftAnchor).isActive = true
        bookmarkView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        bookmarkView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        // weight graph stack
        weightGraphStack.topAnchor.constraint(equalTo: bookmarkView.bottomAnchor).isActive = true
        weightGraphStack.leftAnchor.constraint(equalTo: bookmarkView.rightAnchor).isActive = true
        weightGraphStack.centerXAnchor.constraint(equalTo: outerView.centerXAnchor).isActive = true
        // stats view
        statsView.topAnchor.constraint(equalTo: weightGraphStack.bottomAnchor, constant: 20).isActive = true
        statsView.leftAnchor.constraint(equalTo: outerView.leftAnchor, constant: 16).isActive = true
        statsView.bottomAnchor.constraint(equalTo: outerView.bottomAnchor, constant: -12).isActive = true
        statsView.rightAnchor.constraint(equalTo: outerView.rightAnchor, constant: -16).isActive = true
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
