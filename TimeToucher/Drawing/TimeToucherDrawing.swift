//
//  TimeToucherDrawing.swift
//  TimeToucher
//
//  Created by Nikolas on 14.09.2021.
//

import Foundation
import UIKit

class TimeToucherDrawing {
    static func arc(name: String, setup: ATimeToucher, bounds: CGRect, center: CGPoint) -> (time: CAShapeLayer, background: CAShapeLayer) {
        let aDegree = CGFloat.pi / 180
        
        let backgroundShapeLayer = CAShapeLayer()
        backgroundShapeLayer.path = UIBezierPath(arcCenter: center,
                                                 radius: setup.radius,
                                            startAngle: 0,
                                            endAngle: .pi * 2,
                                            clockwise: true).cgPath
        backgroundShapeLayer.strokeColor = setup.backgroundColor.cgColor
        backgroundShapeLayer.lineWidth = setup.lineWidth
        backgroundShapeLayer.fillColor = UIColor.clear.cgColor
        backgroundShapeLayer.name = "background" + name
        
        let timeShapeLayer = CAShapeLayer()
        timeShapeLayer.path = UIBezierPath(arcCenter: center,
                                           radius: setup.radius,
                                           startAngle: aDegree * setup.startDegree,
                                           endAngle: aDegree * (setup.startDegree + 360 * setup.percentage / 100),
                                      clockwise: true).cgPath
        timeShapeLayer.strokeColor  = setup.color.cgColor
        timeShapeLayer.lineWidth = setup.lineWidth
        timeShapeLayer.fillColor = UIColor.clear.cgColor
        timeShapeLayer.position = center
        timeShapeLayer.bounds = bounds
        timeShapeLayer.name = name
        
        return (timeShapeLayer, backgroundShapeLayer)
    }
    
    static func line(start: CGPoint, end: CGPoint, setup: LTimeToucher) -> CAShapeLayer{
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: start.x, y: start.y))
        path.addLine(to: CGPoint(x: end.x,
                                 y: end.y))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        if let color = setup.color{
            shapeLayer.strokeColor = color.cgColor
        }else{
            shapeLayer.strokeColor = UIColor.random.cgColor
        }
        shapeLayer.lineWidth = setup.width
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.strokeEnd = 0
        
        return shapeLayer
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 0.9
        )
    }
}
