//
//  TimeToucherAnimation.swift
//  TimeToucher
//
//  Created by Nikolas on 28.08.2021.
//

import Foundation
import UIKit

internal class TimeToucherAnimation {
    static func getShapeLayerAnimation(arc: ATimeToucher) -> CABasicAnimation{
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.byValue = NSNumber(floatLiteral: Double(CGFloat.pi * 2))
        animation.duration = arc.animationDuration
        animation.repeatCount = .infinity
        return animation
    }
}
