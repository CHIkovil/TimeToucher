//
//  TimeToucherAnimation.swift
//  TimeToucher
//
//  Created by Nikolas on 28.08.2021.
//

import Foundation
import UIKit

internal class TimeToucherAnimation {
    static func arc(arcSetup: ATimeToucher) -> CABasicAnimation{
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.byValue = NSNumber(floatLiteral: Double(CGFloat.pi * 2))
        animation.duration = arcSetup.animationDuration
        animation.repeatCount = .infinity
        return animation
    }
    
    static func line(lineSetup: LTimeToucher) -> CABasicAnimation{
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = lineSetup.animationDuration
        animation.timingFunction = CAMediaTimingFunction(
            name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.fillMode = CAMediaTimingFillMode.both
        animation.isRemovedOnCompletion = true
        return animation
    }
}
