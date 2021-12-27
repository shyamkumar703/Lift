//
//  BookmarkLabel.swift
//  Lift
//
//  Created by Shyam Kumar on 12/25/21.
//

import Foundation
import UIKit

struct BookmarkLabelModel {
    var title: NSMutableAttributedString
    var color: UIColor
    
    init(
        title: String = "",
        sub: String = "",
        color: UIColor = .liftTeal
    ) {
        let titleAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.regularFont.withSize(16),
            .foregroundColor: UIColor.white
        ]
        let subAttrs: [NSAttributedString.Key: Any] = [
            .font: UIFont.regularFont.withSize(10),
            .foregroundColor: UIColor.white
        ]
        self.title = constructAttributedString(
            str1: title,
            attr1: titleAttrs,
            str2: sub,
            attr2: subAttrs
        )
        self.color = color
    }
}

class BookmarkLabel: UIView {
    
    var model: BookmarkLabelModel = BookmarkLabelModel() {
        didSet {
            updateView()
        }
    }
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.curveCorners(cornerRadius: 10, mask: [.layerMinXMinYCorner])
        return view
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
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
        addSubview(backgroundView)
        backgroundView.addSubview(label)
    }
    
    func setupConstraints() {
        constrain(view: backgroundView, to: self)
        constrain(view: label, to: backgroundView, constant: 4)
    }
    
    func updateView() {
        backgroundView.backgroundColor = model.color
        label.attributedText = model.title
    }
}
