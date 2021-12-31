//
//  Globals.swift
//  Lift
//
//  Created by Shyam Kumar on 12/24/21.
//

import Foundation
import UIKit

let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)

var timeElapsedFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "mm: ss"
    return formatter
}()

var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMM yyyy"
    return formatter
}()

var numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
}()

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

func stringFromInterval(interval: TimeInterval) -> String {
    let minutes = Int(interval / 60)
    let seconds = Int(interval.truncatingRemainder(dividingBy: 60))
    if seconds < 10 {
        return "\(minutes):0\(seconds)"
    }
    return "\(minutes):\(seconds)"
}

func feedback() {
    feedbackGenerator.prepare()
    feedbackGenerator.impactOccurred()
}

extension UIViewController {
    func willDisappear() {
        if let presentingView = self.presentingViewController as? Reloadable {
            presentingView.reload()
        }
    }
}

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    func timeElapsed(toDate: Date) -> String {
        return stringFromInterval(interval: toDate - self)
    }
}
