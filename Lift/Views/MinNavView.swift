//
//  MinNavView.swift
//  Lift
//
//  Created by Shyam Kumar on 12/26/21.
//

import UIKit

struct MinNavViewModel {
    var title: String
    var button: UIButton
    
    init(title: String = "", button: UIButton = UIButton()) {
        self.title = title
        self.button = button
    }
}

class MinNavView: UIView {
    
    var model: MinNavViewModel = MinNavViewModel() {
        didSet {
            updateView()
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .regularFont.withSize(25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        backgroundColor = .clear
        addSubview(titleLabel)
    }
    
    func setupConstraints() {
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
    }
    
    func updateView() {
        titleLabel.text = model.title
        // Constrain and add button
        addSubview(model.button)
        model.button.translatesAutoresizingMaskIntoConstraints = false
        model.button.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        model.button.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
    }

}
