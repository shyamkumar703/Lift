//
//  LineChart.swift
//  Lift
//
//  Created by Shyam Kumar on 12/25/21.
//

import Foundation
import UIKit

class LineChart: UIView, UIGestureRecognizerDelegate, Animatable {
    var lineColor: UIColor = .liftTeal
    var dataPoints: [(Int, Int)] = {
        var interArr: [(Int, Int)] = []
        for i in 1...36 {
            let randomInt = Int.random(in: 0...30)
            interArr.append((i, randomInt))
        }
        return interArr
    }()
    let shapeLayer = CAShapeLayer()
    var pointArr: [CGPoint] = []
    let lineLayer = CAShapeLayer()
    var graphLayer = CAShapeLayer()
    var pointChangedCompletion: (CGPoint, CGPoint) -> Void = {_,_  in return}
    var dragEndedCompletion: () -> Void = {return}
    var animated: Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        self.isUserInteractionEnabled = true
        let panGestureRecognizer: UIGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        panGestureRecognizer.delegate = self
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func awakeFromNib() {
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        let results = drawGraph()
        pointArr = results.0
        drawCircleIndicator(point: pointArr.last!, color: lineColor)
    }
    
    @objc func panGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            return
        case .changed:
            let point = getClosestPoint(point: sender.location(in: self))
            drawCircleIndicator(point: point, color: .black, addLayer: false, showLine: true)
            pointChangedCompletion(point, pointArr.last!)
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        case .ended:
            shapeLayer.strokeColor = lineColor.cgColor
            drawCircleIndicator(point: pointArr.last!, color: lineColor)
            dragEndedCompletion()
        default:
            return
        }
    }
    
    func getClosestPoint(point: CGPoint) -> CGPoint {
        var closestPoint: CGPoint = CGPoint()
        var distance: CGFloat = CGFloat.infinity
        
        for loopPoint in pointArr {
            let currDistance = abs(loopPoint.x - point.x)
            if currDistance < distance {
                closestPoint = loopPoint
                distance = currDistance
            }
        }
        return closestPoint
    }
    
    func drawCircleIndicator(point: CGPoint, color: UIColor, addLayer: Bool = true, showLine: Bool = false) {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: point.x + 3, y: point.y - 3), radius: 4, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 2.5
        shapeLayer.fillColor = UIColor.white.cgColor
        
        let height = self.bounds.height - 5
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: point.x + 3, y: 5))
        linePath.addLine(to: CGPoint(x: point.x + 3, y: height))
        
        lineLayer.path = linePath.cgPath
        lineLayer.strokeColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        lineLayer.lineWidth = 2
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.lineCap = .round
        
        if showLine {
            layer.addSublayer(lineLayer)
        } else {
            lineLayer.removeFromSuperlayer()
        }
        
        if addLayer {
            layer.addSublayer(shapeLayer)
        }
        
    }
    
    func drawGraph() -> ([CGPoint], UIBezierPath) {
        var pointArr: [CGPoint] = []
        for tuple in dataPoints {
            pointArr.append(normalizeDataPoint(x: tuple.0, y: tuple.1))
        }
        lineColor.setFill()
        lineColor.setStroke()
        let graphPath = UIBezierPath()
        graphPath.lineWidth = 2
        
        graphPath.move(to: pointArr[0])
        for i in 1..<pointArr.count {
            let nextPoint = pointArr[i]
            graphPath.addLine(to: nextPoint)
        }
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.path = graphPath.cgPath
        graphLayer = shapeLayer
        layer.addSublayer(graphLayer)
        
        
        return (pointArr, graphPath)
    }
    
    func animate() {
        if !animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.duration = 1.3
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            graphLayer.add(animation, forKey: "animation")
            animated = true
        }
    }
    
    func normalizeDataPoint(x: Int, y: Int) -> CGPoint {
        let width = self.bounds.width - 15
        let height = self.bounds.height - 5
        
        let maxX = CGFloat(dataPoints.map {$0.0}.max() ?? 0)
        let minX = CGFloat(dataPoints.map {$0.0}.min() ?? 0)
        let maxY = CGFloat(dataPoints.map {$0.1}.max() ?? 0)
        let minY = CGFloat(dataPoints.map {$0.1}.min() ?? 0)
        
        let xNorm = ((CGFloat(x) - minX) / (maxX - minX)) * (width/1.2) + (width / 9.6)
        let yNorm = height - (((CGFloat(y) - minY) / (maxY - minY)) * (height / 1.2)) - (height / 9.6)
        
        return CGPoint(x: xNorm, y: yNorm)
    }
}

protocol Animatable {
    func animate() -> Void
}
