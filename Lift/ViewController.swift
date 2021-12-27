//
//  ViewController.swift
//  Lift
//
//  Created by Shyam Kumar on 12/24/21.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var nav: MinNavView = {
        var nav = MinNavView()
        var model = MinNavViewModel(title: "My Workouts")
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.setImage(UIImage(systemName: "plus"), for: .normal)
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
    }
}

