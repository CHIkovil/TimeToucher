//
//  TimeToucherDrawing.swift
//  TimeToucher
//
//  Created by Nikolas on 28.08.2021.
//

import Foundation
import UIKit

internal class TimeToucherDrawing {
    static func getArcShapeLayer(centerPoint: CGPoint, arc: ATimeToucher) -> ArcShapeLayer{
        let aDegree = CGFloat.pi / 180
        
        let backgroundShapeLayer = CAShapeLayer()
        backgroundShapeLayer.path = UIBezierPath(arcCenter: centerPoint,
                                            radius: arc.radius,
                                            startAngle: 0,
                                            endAngle: .pi * 2,
                                            clockwise: true).cgPath
        backgroundShapeLayer.strokeColor = arc.backgroundColor.cgColor
        backgroundShapeLayer.lineWidth = arc.lineWidth
        backgroundShapeLayer.fillColor = UIColor.clear.cgColor
        
        let timeShapeLayer = CAShapeLayer()
        timeShapeLayer.path = UIBezierPath(arcCenter: centerPoint,
                                      radius: arc.radius,
                                      startAngle: aDegree * arc.startDegree,
                                      endAngle: aDegree * (arc.startDegree + 360 * arc.percentage / 100),
                                      clockwise: true).cgPath
        timeShapeLayer.strokeColor  = arc.color.cgColor
        timeShapeLayer.lineWidth = arc.lineWidth
        timeShapeLayer.fillColor = UIColor.clear.cgColor
        timeShapeLayer.position = centerPoint
        
        return ArcShapeLayer(time: timeShapeLayer, background: backgroundShapeLayer)
    }
}
