//
//  Globals.swift
//  Lift
//
//  Created by Shyam Kumar on 12/24/21.
//

import Foundation
import UIKit

func constructAttributedString(
    str1: String,
    attr1: [NSAttributedString.Key: Any],
    str2: String,
    attr2: [NSAttributedString.Key: Any]
) -> NSMutableAttributedString {
    let mutStr1 = NSMutableAttributedString(string: str1, attributes: attr1)
    let mutStr2 = NSMutableAttributedString(string: " " + str2, attributes: attr2)
    mutStr1.append(mutStr2)
    return mutStr1
}

func constrain(view: UIView, to: UIView, constant: CGFloat = 0) {
    view.topAnchor.constraint(equalTo: to.topAnchor, constant: constant).isActive = true
    view.leftAnchor.constraint(equalTo: to.leftAnchor, constant: constant).isActive = true
    view.rightAnchor.constraint(equalTo: to.rightAnchor, constant: -1 * constant).isActive = true
    view.bottomAnchor.constraint(equalTo: to.bottomAnchor, constant: -1 * constant).isActive = true
}
