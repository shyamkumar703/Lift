//
//  TopNavView.swift
//  Lift
//
//  Created by Shyam Kumar on 12/24/21.
//

import Foundation
import UIKit

protocol NavDelegate {
    func switchToHistory()
    func switchToTrends()
}

class TopNavView: UIView {
    
    var indicatorStartX: NSLayoutConstraint?
    var indicatorEndX: NSLayoutConstraint?
    
    var selectionChanged: Bool = false
    
    var delegate: NavDelegate?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "My Workouts"
        label.font = .regularFont.withSize(25)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var menuStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 20
        
        stack.addArrangedSubview(history)
        stack.addArrangedSubview(trends)
        return stack
    }()
    
    lazy var history: UILabel = {
        let label = UILabel()
        label.text = "History"
        label.font = .regularFont.withSize(15)
        label.textColor = .liftGreen
        label.tag = 0
        label.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(menuTapped))
        label.addGestureRecognizer(tapGesture)
        
        return label
    }()
    
    lazy var trends: UILabel = {
        let label = UILabel()
        label.text = "Trends"
        label.font = .regularFont.withSize(15)
        label.textColor = .gray
        label.tag = 1
        label.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(menuTapped))
        label.addGestureRecognizer(tapGesture)
        
        return label
    }()
    
    lazy var indicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .liftGreen
        return view
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
        addSubview(titleLabel)
        addSubview(menuStack)
        addSubview(indicator)
    }
    
    func setupConstraints() {
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        
        menuStack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        menuStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3).isActive = true
        
        indicatorStartX = indicator.leftAnchor.constraint(equalTo: history.leftAnchor, constant: -8)
        indicatorEndX = indicator.rightAnchor.constraint(equalTo: history.rightAnchor, constant: 8)
        
        indicatorStartX?.isActive = true
        indicatorEndX?.isActive = true
        indicator.topAnchor.constraint(equalTo: menuStack.bottomAnchor, constant: 1).isActive = true
    }
    
    @objc func menuTapped(_ sender: UITapGestureRecognizer) {
        var newLabel = history
        var oldLabel = trends
        if let view = sender.view {
            if view.tag == 0 {
                if selectionChanged == false { return }
                indicatorStartX?.constant = -8
                indicatorEndX?.constant = 8
                delegate?.switchToHistory()
            } else {
                if selectionChanged == true { return }
                indicatorStartX?.constant = 20 + history.bounds.width
                indicatorEndX?.constant = 20 + trends.bounds.width
                newLabel = trends
                oldLabel = history
                delegate?.switchToTrends()
            }
            selectionChanged = !selectionChanged
            UIView.animate(withDuration: 0.3, animations: {
                self.superview?.layoutIfNeeded()
                newLabel.textColor = .liftGreen
                oldLabel.textColor = .gray
            })
        }
    }
}
