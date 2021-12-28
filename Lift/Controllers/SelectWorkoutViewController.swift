//
//  SelectWorkoutViewController.swift
//  Lift
//
//  Created by Shyam Kumar on 12/27/21.
//

import UIKit

class SelectWorkoutViewController: UIViewController {
    
    lazy var nav: MinNavView = {
        var nav = MinNavView()
        var model = MinNavViewModel(title: "Workouts")
        
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
            MinHistoryTableViewCellModel(color: .liftRed, name: "Pull", ipArr: [
                "LAT PULLDOWN",
                "LAT TWIST",
                "CABLE ROW",
                "HAMMER CURLS",
                "CABLE CURLS",
                "21s",
                "REAR DELT EXTENSION"
            ]),
            MinHistoryTableViewCellModel(color: .liftTeal, name: "Push", ipArr: [
                "BENCH PRESS",
                "MACHINE INCLINE",
                "MACHINE FLY",
                "LAT RAISE",
                "TRICEP PUSHDOWN",
                "TRICEP EXTENSION",
                "REAR DELT EXTENSION"
            ]),
            MinHistoryTableViewCellModel(color: .liftPurple, name: "Legs", ipArr: [
                "HACK SQUAT",
                "HAMSTRING CURLS",
                "LEG EXTENSIONS",
                "REAR DELT EXTENSION"
            ])
        ])
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(nav)
        view.addSubview(table)
    }
    
    func setupConstraints() {
        nav.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        nav.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        nav.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nav.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        table.topAnchor.constraint(equalTo: nav.bottomAnchor).isActive = true
        table.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        table.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc func plusPressed() {
        present(CreateWorkoutViewController(), animated: true, completion: nil)
    }
    
    
}
