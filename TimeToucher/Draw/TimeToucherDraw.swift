//
//  TimeToucherDraw.swift
//  TimeToucher
//
//  Created by Nikolas on 28.08.2021.
//

import Foundation
import UIKit

internal class TimeToucherDraw {
    static func arc(center: CGPoint, arcSetup: ATimeToucher) -> ArcShapeLayer{
        let aDegree = CGFloat.pi / 180
        
        let backgroundShapeLayer = CAShapeLayer()
        backgroundShapeLayer.path = UIBezierPath(arcCenter: center,
                                            radius: arcSetup.radius,
                                            startAngle: 0,
                                            endAngle: .pi * 2,
                                            clockwise: true).cgPath
        backgroundShapeLayer.strokeColor = arcSetup.backgroundColor.cgColor
        backgroundShapeLayer.lineWidth = arcSetup.lineWidth
        backgroundShapeLayer.fillColor = UIColor.clear.cgColor
        
        let timeShapeLayer = CAShapeLayer()
        timeShapeLayer.path = UIBezierPath(arcCenter: center,
                                      radius: arcSetup.radius,
                                      startAngle: aDegree * arcSetup.startDegree,
                                      endAngle: aDegree * (arcSetup.startDegree + 360 * arcSetup.percentage / 100),
                                      clockwise: true).cgPath
        timeShapeLayer.strokeColor  = arcSetup.color.cgColor
        timeShapeLayer.lineWidth = arcSetup.lineWidth
        timeShapeLayer.fillColor = UIColor.clear.cgColor
        timeShapeLayer.position = center
        
        return ArcShapeLayer(time: timeShapeLayer, background: backgroundShapeLayer)
    }
    
    static func line(start: CGPoint, end: CGPoint, linesSetup: LTimeToucher) -> CAShapeLayer{
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: start.x, y: start.y))
        path.addLine(to: CGPoint(x: end.x,
                                 y: end.y))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        if let color = linesSetup.color{
            shapeLayer.strokeColor = color.cgColor
        }else{
            shapeLayer.strokeColor = UIColor.random.cgColor
        }
        shapeLayer.lineWidth = linesSetup.width
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.strokeEnd = 0
        return shapeLayer
    }
}

internal extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 0.9
        )
    }
}
