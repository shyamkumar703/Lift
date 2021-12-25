//
//  UIView+Lift.swift
//  Lift
//
//  Created by Shyam Kumar on 12/24/21.
//

import Foundation
import UIKit

extension UIView {
    func curveCorners(cornerRadius: CGFloat, mask: CACornerMask) {
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = mask
    }
}
