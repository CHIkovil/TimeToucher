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
    
    public var animationLinesSetup: LTimeToucher {
        return LTimeToucher(countAnimation: 5)
    }
    
    public func animateArcs(){
        self.isMultipleTouchEnabled = true
      
        for arc in arcsSetup.directory{
            let arcShapeLayer = TimeToucherDrawing.getArcShapeLayer(centerPoint: CGPoint(x: frame.size.width/2, y: frame.size.height/2), arc: arc.value)
            arcShapeLayer.time.bounds = self.layer.bounds
            arcShapeLayer.time.name = arc.key
            
            let arcAnimation = TimeToucherAnimation.getShapeLayerAnimation(arc: arc.value)
            arcShapeLayer.time.add(arcAnimation, forKey: arc.key)
            
            self.layer.addSublayer(arcShapeLayer.background)
            self.layer.addSublayer(arcShapeLayer.time)
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch  = touches.first {
            let touchPoint = touch.location(in: self)
            
            let arcName = arcsSetup.maxArc.name
            let arcRadius = arcsSetup.maxArc.value.radius
            let arcLineWidth = arcsSetup.maxArc.value.lineWidth
            
            let centerMaxArc:CGPoint = (self.layer.sublayers?.filter({$0.name == arcName}).first!.position)!
            
            if TimeToucherCalculation.checkCircleContainsPoint(point: touchPoint, circleCenter: centerMaxArc, circleRadius: arcRadius + arcLineWidth / 2){
                return
            }
            
            let arrayFrontArc = TimeToucherCalculation.getArrayTouchFrontArc(touchPoint: touchPoint, circleCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), circleRadius: arcsSetup.hourArc.radius + arcsSetup.hourArc.lineWidth / 2, countPoint: animationLinesSetup.countAnimation)
            
            print(arrayFrontArc.count)
            
            for i in arrayFrontArc {
                let layer = CAShapeLayer()
                layer.path = UIBezierPath(arcCenter: i,
                                                    radius: 5,
                                                    startAngle: 0,
                                                    endAngle: .pi * 2,
                                                    clockwise: true).cgPath
                layer.strokeColor = UIColor.black.cgColor
                layer.fillColor = UIColor.black.cgColor
                self.layer.addSublayer(layer)
            }
        }
    }
}

private extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 0.9
        )
    }
}
