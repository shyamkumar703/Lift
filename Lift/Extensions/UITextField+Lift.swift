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
    case completedReps = "completedReps"
    case completedWeight = "completedWeight"
}

extension UITextField {
    func getTextType() -> TextType? {
        switch tag {
        case 1:
            return .reps
        case 2:
            return .weight
        case 3:
            return .completedReps
        case 4:
            return .completedWeight
        default:
            return nil
        }
    }
}
