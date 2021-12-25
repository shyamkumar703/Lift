//
//  StatsView.swift
//  Lift
//
//  Created by Shyam Kumar on 12/24/21.
//

import Foundation
import UIKit

struct StatsViewModel {
    var segOne: NSMutableAttributedString
    var segTwo: NSMutableAttributedString
    var segThree: NSMutableAttributedString
    
    init(
        segOneTitle: String = "",
        segOneSub: String = "",
        segTwoTitle: String = "",
        segTwoSub: String = "",
        segThreeTitle: String = "",
        segThreeSub: String = ""
    ) {
        let boldAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldFont.withSize(16)
        ]
        let smallAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.regularFont.withSize(12)
        ]
        
        segOne = constructAttributedString(str1: segOneTitle, attr1: boldAttrs, str2: segOneSub, attr2: smallAttrs)
        segTwo = constructAttributedString(str1: segTwoTitle, attr1: boldAttrs, str2: segTwoSub, attr2: smallAttrs)
        segThree = constructAttributedString(str1: segThreeTitle, attr1: boldAttrs, str2: segThreeSub, attr2: smallAttrs)
    }
}

class StatsView: UIView {
    
    lazy var outerStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        return stack
    }()
    
    func statFactory(title: NSMutableAttributedString, alignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.attributedText = title
        label.textAlignment = alignment
        label.numberOfLines = 2
        return label
    }
    
    var model: StatsViewModel = StatsViewModel() {
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
        addSubview(outerStackView)
    }
    
    func setupConstraints() {
        outerStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        outerStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        outerStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        outerStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func updateView() {
        outerStackView.addArrangedSubview(statFactory(title: model.segOne, alignment: .left))
        outerStackView.addArrangedSubview(statFactory(title: model.segTwo, alignment: .center))
        outerStackView.addArrangedSubview(statFactory(title: model.segThree, alignment: .right))
    }
}
