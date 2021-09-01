//
//  TimeToucher.swift
//  TimeToucher
//
//  Created by Nikolas on 26.08.2021.
//

import Foundation
import UIKit

public final class TimeToucher: UIView {
    let name = "TimeToucher"
    
    public var arcsSetup: ASTimeToucher {
        let secondArc = ATimeToucher(percentage: 40, lineWidth: 20, radius: 20, startDegree: 0, color: .random, backgroundColor: .lightGray, animationDuration: 10)
        let minuteArc = ATimeToucher(percentage: 40, lineWidth: 20, radius: 50, startDegree: 70, color: .random, backgroundColor: .lightGray,  animationDuration: 20)
        let hourArc = ATimeToucher(percentage: 40, lineWidth: 20, radius: 80, startDegree: 180, color: .random,backgroundColor: .lightGray,  animationDuration: 30)
        return ASTimeToucher(secondArc: secondArc, minuteArc: minuteArc, hourArc: hourArc)
    }
    
    public var linesSetup: LTimeToucher {
        return LTimeToucher(countAnimation: 10, animationDuration: 0.7, width: 5, color: UIColor.random)
    }
    
    public func animateArcs(){
        self.isMultipleTouchEnabled = true
        
        for arc in arcsSetup.directory{
            let arcShapeLayer = TimeToucherDrawing.arc(center: CGPoint(x: frame.size.width/2, y: frame.size.height/2), arcSetup: arc.value)
            arcShapeLayer.time.bounds = self.layer.bounds
            arcShapeLayer.time.name = arc.key
            
            let arcAnimation = TimeToucherAnimation.arc(arcSetup: arc.value)
            arcShapeLayer.time.add(arcAnimation, forKey: arc.key)
            
            self.layer.addSublayer(arcShapeLayer.background)
            self.layer.addSublayer(arcShapeLayer.time)
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touchesLocation = touches.map { return $0.location(in: self)}
        var touchPoint = touchesLocation.first!
        
        switch touches.count {
        case 3:
            guard let touchCenter = TimeToucherCalculation.circleCenterTouchingThreePoints(a: touchesLocation[0], b: touchesLocation[1], c: touchesLocation[2]) else {
                fallthrough
            }
            touchPoint = touchCenter
        case 2:
            touchPoint = TimeToucherCalculation.circleCenterTouchingTwoPoints(a: touchesLocation[0], b: touchesLocation[1])
        default: break
        }
        
        let arcName = arcsSetup.maxArc.name
        let arcRadius = arcsSetup.maxArc.value.radius
        let arcLineWidth = arcsSetup.maxArc.value.lineWidth
        
        let centerMaxArc:CGPoint = (self.layer.sublayers?.filter({$0.name == arcName}).first!.position)!
        
        if TimeToucherCalculation.checkCircleContainsPoint(point: touchPoint, circleCenter: centerMaxArc, circleRadius: arcRadius + arcLineWidth / 2){
            return
        }
        
        let arrayFrontArc = TimeToucherCalculation.arrayTouchingFrontArc(touchPoint: touchPoint, circleCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), circleRadius: arcsSetup.hourArc.radius + arcsSetup.hourArc.lineWidth / 2, countPoint: linesSetup.countAnimation)
        
        for frontPoint in arrayFrontArc{
            let lineShapeLayer = TimeToucherDrawing.line(start: frontPoint, end: touchPoint, linesSetup: linesSetup)
            let lineAnimation = TimeToucherAnimation.line(lineSetup:linesSetup)
            lineShapeLayer.add(lineAnimation, forKey: nil)
            self.layer.addSublayer(lineShapeLayer)
        }
//        print(arrayFrontArc.count)
//
//        for i in arrayFrontArc {
//            let layer = CAShapeLayer()
//            layer.path = UIBezierPath(arcCenter: i,
//                                      radius: 5,
//                                      startAngle: 0,
//                                      endAngle: .pi * 2,
//                                      clockwise: true).cgPath
//            layer.strokeColor = UIColor.black.cgColor
//            layer.fillColor = UIColor.black.cgColor
//            self.layer.addSublayer(layer)
//        }
    }
}


