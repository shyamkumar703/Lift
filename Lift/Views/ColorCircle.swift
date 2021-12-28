//
//  ColorCircle.swift
//  Lift
//
//  Created by Shyam Kumar on 12/26/21.
//

import UIKit

struct ColorCircleModel {
    var color: UIColor
    var dim: CGFloat
    
    init(color: UIColor = .liftTeal, dim: CGFloat = 0) {
        self.color = color
        self.dim = 0
    }
}

class ColorCircle: UIView {
    
    var model: ColorCircleModel = ColorCircleModel() {
        didSet {
            updateView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView() {
        layer.cornerRadius = model.dim / 2
        backgroundColor = model.color
    }

}
