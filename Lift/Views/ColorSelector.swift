//
//  ColorSelector.swift
//  Lift
//
//  Created by Shyam Kumar on 12/27/21.
//

import UIKit

protocol ColorSelectorDelegate {
    func selectionChanged(color: UIColor?)
}

struct ColorSelectorModel {
    var options: [UIColor] = []
    
    init(options: [UIColor] = [.liftRed, .liftTeal, .liftPurple]) {
        self.options = options
    }
}

class ColorSelector: UIView, UIGestureRecognizerDelegate {
    
    var currentSelection: Int = 0
    var delegate: ColorSelectorDelegate?
    
    var model: ColorSelectorModel = ColorSelectorModel() {
        didSet {
            updateView()
        }
    }
    
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
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
        addSubview(stack)
    }
    
    func setupConstraints() {
        stack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stack.widthAnchor.constraint(equalToConstant: 88).isActive = true
        stack.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    func updateView() {
        for i in 0..<model.options.count {
            stack.addArrangedSubview(optionFactory(color: model.options[i], isSelected: i == 0, tag: i))
        }
    }
    
    func optionFactory(color: UIColor, isSelected: Bool = false, tag: Int = 0) -> UIView {
        let outerView = UIView()
        outerView.layer.cornerRadius = 12
        outerView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        outerView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        outerView.backgroundColor = .clear
        outerView.layer.borderWidth = 0.5
        outerView.tag = tag
        outerView.clipsToBounds = true
        
        if isSelected {
            outerView.layer.borderColor = UIColor.black.cgColor
        } else {
            outerView.layer.borderColor = UIColor.clear.cgColor
        }
        
        let innerView = UIView()
        innerView.translatesAutoresizingMaskIntoConstraints = false
        innerView.layer.cornerRadius = 10
        outerView.addSubview(innerView)
        innerView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        innerView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        innerView.centerXAnchor.constraint(equalTo: outerView.centerXAnchor).isActive = true
        innerView.centerYAnchor.constraint(equalTo: outerView.centerYAnchor).isActive = true
        innerView.backgroundColor = color
        innerView.isUserInteractionEnabled = true
        innerView.tag = tag
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(innerViewTapped))
        innerView.addGestureRecognizer(tapGesture)
        innerView.clipsToBounds = true
        
        return outerView
    }
    
    @objc func innerViewTapped(_ gr: UITapGestureRecognizer) {
        if let view = gr.view,
           let superview = view.superview {
            if view.tag == currentSelection { return }
            deselectCurrentView()
            superview.layer.borderColor = UIColor.black.cgColor
            currentSelection = view.tag
            delegate?.selectionChanged(color: view.backgroundColor)
        }
    }
    
    func deselectCurrentView() {
        if let outerView = stack.arrangedSubviews.filter({$0.tag == currentSelection}).first {
            outerView.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
