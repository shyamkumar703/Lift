//
//  ViewController.swift
//  Lift
//
//  Created by Shyam Kumar on 12/24/21.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var nav: TopNavView = {
        let view = TopNavView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundGray
        view.translatesAutoresizingMaskIntoConstraints = false
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
        view.addSubview(bottomView)
    }
    
    func setupConstraints() {
        nav.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        nav.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        nav.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nav.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        bottomView.topAnchor.constraint(equalTo: nav.bottomAnchor).isActive = true
        bottomView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }


}

