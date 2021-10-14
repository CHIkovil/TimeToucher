//
//  TimeToucherAnimation.swift
//  TimeToucher
//
//  Created by Nikolas on 14.09.2021.
//

import Foundation
import UIKit

class TimeToucherAnimation {
    static func infinityArcRotate(setup: ATimeToucher) -> CABasicAnimation{
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.byValue = NSNumber(floatLiteral: Double(CGFloat.pi * 2))
        animation.duration = setup.animationDuration
        animation.repeatCount = .infinity
        return animation
    }
    
    static func line(setup: LTimeToucher) -> CABasicAnimation{
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = setup.animationDuration
        animation.timingFunction = CAMediaTimingFunction(
            name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.fillMode = CAMediaTimingFillMode.both
        animation.isRemovedOnCompletion = true
        return animation
    }
    
    static func rotateArc(toAngle: CGFloat) -> CATransform3D{
        let radians = CGFloat(toAngle * .pi/180)
        let rotationTransform = CATransform3DMakeRotation(radians, 0.0, 0.0, 1.0)
        return rotationTransform
    }
}
