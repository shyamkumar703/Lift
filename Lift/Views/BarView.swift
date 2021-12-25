//
//  BarView.swift
//  Lift
//
//  Created by Shyam Kumar on 12/24/21.
//

import UIKit

struct BarViewModel {
    var segOne: NSMutableAttributedString
    var segTwo: NSMutableAttributedString
    var segThree: NSMutableAttributedString
    var segOneColor: UIColor
    
    init(
        segOneTitle: String = "",
        segOneSub: String = "",
        segTwoTitle: String = "",
        segTwoSub: String = "",
        segThreeTitle: String = "",
        segThreeSub: String = "",
        segOneColor: UIColor = .liftTeal
    ) {
        let segOneLargeAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.regularFont.withSize(20),
            .foregroundColor: UIColor.white
        ]
        let segOneSmallAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.regularFont.withSize(12),
            .foregroundColor: UIColor.white
        ]
        let segLargeAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.regularFont.withSize(20),
            .foregroundColor: UIColor.black
        ]
        let segSmallAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.regularFont.withSize(12),
            .foregroundColor: UIColor.black
        ]
        segOne = constructAttributedString(
            str1: segOneTitle,
            attr1: segOneLargeAttrs,
            str2: segOneSub,
            attr2: segOneSmallAttrs
        )
        segTwo = constructAttributedString(
            str1: segTwoTitle,
            attr1: segLargeAttrs,
            str2: segTwoSub,
            attr2: segSmallAttrs
        )
        segThree = constructAttributedString(
            str1: segThreeTitle,
            attr1: segLargeAttrs,
            str2: segThreeSub,
            attr2: segSmallAttrs
        )
        
        self.segOneColor = segOneColor
    }
}

class BarView: UIView {
    
    lazy var outerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 4
        
        return stack
    }()
    
    func segmentFactory(title: NSAttributedString, color: UIColor, corners: CACornerMask) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.curveCorners(cornerRadius: 10, mask: corners)
        
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = title
        
        view.addSubview(label)
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -4).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
    }
    
    var model: BarViewModel = BarViewModel() {
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
        addSubview(outerStack)
    }
    
    func setupConstraints() {
        outerStack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        outerStack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        outerStack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        outerStack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    }
    
    func updateView() {
        outerStack.addArrangedSubview(segmentFactory(title: model.segOne, color: model.segOneColor, corners: [.layerMinXMaxYCorner, .layerMinXMinYCorner]))
        outerStack.addArrangedSubview(segmentFactory(title: model.segTwo, color: .barGray, corners: []))
        outerStack.addArrangedSubview(segmentFactory(title: model.segThree, color: .barGray, corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]))
    }
}
