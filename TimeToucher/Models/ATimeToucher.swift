//
//  ATimeToucher.swift
//  TimeToucher
//
//  Created by Nikolas on 26.08.2021.
//

import Foundation
import UIKit

public struct ATimeToucher{
    let percentage: CGFloat
    let lineWidth: CGFloat
    let radius: CGFloat
    let startDegree: CGFloat
    let color: UIColor
    let backgroundColor: UIColor
    let animationDuration: Double
    
    let animationLineSetup: LTimeToucher
    
    public init(percentage: CGFloat, lineWidth: CGFloat, radius: CGFloat, startDegree: CGFloat, color: UIColor, backgroundColor: UIColor, animationDuration: Double, animationLineSetup: LTimeToucher) {
        self.percentage = percentage
        self.lineWidth = lineWidth
        self.radius = radius
        self.startDegree = startDegree
        self.color = color
        self.backgroundColor = backgroundColor
        self.animationDuration = animationDuration
        self.animationLineSetup = animationLineSetup
    }
}
