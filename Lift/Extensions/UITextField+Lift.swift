//
//  UITextField+Lift.swift
//  Lift
//
//  Created by Shyam Kumar on 12/27/21.
//

import Foundation
import UIKit

enum TextType: String {
    case reps = "reps"
    case weight = "lbs"
}

extension UITextField {
    func getTextType() -> TextType? {
        switch tag {
        case 1:
            return .reps
        case 2:
            return .weight
        default:
            return nil
        }
    }
}
