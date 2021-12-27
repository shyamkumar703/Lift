//
//  IPLabel.swift
//  Lift
//
//  Created by Shyam Kumar on 12/26/21.
//

import UIKit

struct IPLabelModel {
    var stats: [String]
    
    init(stats: [String] = []) {
        self.stats = stats
    }
}

class IPLabel: UIView {
    
    var model: IPLabelModel = IPLabelModel() {
        didSet {
            updateView()
        }
    }
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .gray
        label.font = .regularFont.withSize(10)
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
        addSubview(label)
    }
    
    func setupConstraints() {
        constrain(view: label, to: self)
    }
    
    func updateView() {
        var str = ""
        for i in 0..<model.stats.count {
            if i != model.stats.count - 1 {
                str += model.stats[i] + " · "
            } else {
                str += model.stats[i]
            }
        }
        label.text = str
    }

}
