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
    
    public var setup: ASTimeToucher?
    
    public func animateArcs(){
        self.isMultipleTouchEnabled = true
        let arcsDirectory = getArcsDirectory()
        
        for arc in arcsDirectory{
            let arcShapeLayer = TimeToucherDrawing.getArcShapeLayer(centerPoint: CGPoint(x: frame.size.width/2, y: frame.size.height/2), arc: arc.value)
            arcShapeLayer.time.bounds = self.layer.bounds
            
            let arcAnimation = TimeToucherAnimation.getShapeLayerAnimation(arc: arc.value)
            arcShapeLayer.time.add(arcAnimation, forKey: arc.key)
            
            self.layer.addSublayer(arcShapeLayer.background)
            self.layer.addSublayer(arcShapeLayer.time)
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch  = touches.first {
            let location = touch.location(in: self)
            print(location)
            
            let array = TimeToucherCalculation.getArrayTouchFrontArc(touchPoint: location, circleCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), circleRadius: setup!.hourArc.radius + setup!.hourArc.lineWidth / 2, countPoint: setup!.hourArc.animationLine.countAnimation)
            
            for i in array {
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

private extension TimeToucher {
    func getArcsDirectory() -> ArcsDirectory{
        switch setup{
        case let setup?:
            return setup.directory
            
        default:
            let animationLineSetup = LTimeToucher(countAnimation: 10)
            
            let secondArc = ATimeToucher(percentage: 40, lineWidth: 20, radius: 20, startDegree: 0, color: .random, backgroundColor: .lightGray, animationDuration: 10, animationLine: animationLineSetup)
            let minuteArc = ATimeToucher(percentage: 40, lineWidth: 20, radius: 50, startDegree: 70, color: .random, backgroundColor: .lightGray,  animationDuration: 20, animationLine: animationLineSetup)
            let hourArc = ATimeToucher(percentage: 40, lineWidth: 20, radius: 80, startDegree: 180, color: .random,backgroundColor: .lightGray,  animationDuration: 30, animationLine: animationLineSetup)
            
            setup = ASTimeToucher(secondArc: secondArc, minuteArc: minuteArc, hourArc: hourArc)
            return setup!.directory
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
