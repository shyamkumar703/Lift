//
//  ViewController.swift
//  Lift
//
//  Created by Shyam Kumar on 12/24/21.
//

import UIKit

enum HomeOptions {
    case workouts
    case trends
}

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var currOption: HomeOptions = .workouts
    
    lazy var nav: MinNavView = {
        var nav = MinNavView()
        var model = MinNavViewModel(title: "My Workouts")
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(plusPressed), for: .touchUpInside)
        model.button = button
        
        nav.model = model
        
        nav.translatesAutoresizingMaskIntoConstraints = false
        return nav
    }()
    
    lazy var table: MinHistoryTableView = {
        let view = MinHistoryTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.model = MinHistoryTableViewModel(cells: [
            MinHistoryTableViewCellModel(color: .liftRed, name: "Pull"),
            MinHistoryTableViewCellModel(color: .liftTeal, name: "Push"),
            MinHistoryTableViewCellModel(color: .liftPurple, name: "Legs")
        ])
        return view
    }()
    
    lazy var trendsTable: MinTrendsTableView = {
        let view = MinTrendsTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.model = MinTrendsTableViewModel(cells: [
            MinTrendsTableViewCellModel(color: .liftRed, title: "Pull", ipArr: ["22 JAN 2022", "35 mins", "+5 lbs"], weightArr: [0, 2, 1, 3]),
            MinTrendsTableViewCellModel(color: .liftTeal, title: "Push", ipArr: ["22 JAN 2022", "35 mins", "+5 lbs"], weightArr: [0, 2, 1, 3]),
            MinTrendsTableViewCellModel(color: .liftPurple, title: "Legs", ipArr: ["22 JAN 2022", "35 mins", "+5 lbs"], weightArr: [0, 2, 1, 3])
        ])
        view.alpha = 0
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        view.addSubview(nav)
        view.addSubview(table)
        view.addSubview(trendsTable)
        
        // Gesture Recognizers
        let gr = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        gr.direction = .left
        view.addGestureRecognizer(gr)
        gr.delegate = self
        
        let gr2 = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        gr2.direction = .right
        view.addGestureRecognizer(gr2)
        gr2.delegate = self
    }
    
    func setupConstraints() {
        nav.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        nav.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        nav.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nav.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        table.topAnchor.constraint(equalTo: nav.bottomAnchor).isActive = true
        table.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        table.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        trendsTable.topAnchor.constraint(equalTo: nav.bottomAnchor).isActive = true
        trendsTable.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        trendsTable.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        trendsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc func swipe(_ gr: UISwipeGestureRecognizer) {
        switch gr.direction {
        case .left:
            if currOption == .trends { return }
            currOption = .trends
            UIView.animate(withDuration: 0.2, animations: { [self] in
                table.alpha = 0
                nav.alpha = 0
            }, completion: { [self] fin in
                nav.model.title = "Trends"
                UIView.animate(withDuration: 0.2, animations: { [self] in
                    trendsTable.alpha = 1
                    nav.alpha = 1
                })
            })
        case .right:
            if currOption == .workouts { return }
            currOption = .workouts
            UIView.animate(withDuration: 0.2, animations: {[self] in
                trendsTable.alpha = 0
                nav.alpha = 0
            }, completion: { [self] fin in
                nav.model.title = "My Workouts"
                UIView.animate(withDuration: 0.2, animations: { [self] in
                    table.alpha = 1
                    nav.alpha = 1
                })
            })
        default:
            return
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
    
    @objc func plusPressed() {
        present(SelectWorkoutViewController(), animated: true, completion: nil)
    }
}

