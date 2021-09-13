//
//  LTimeToucher.swift
//  TimeToucher
//
//  Created by Nikolas on 29.08.2021.
//

import Foundation
import UIKit

public struct LTimeToucher {
    let count: Int
    let animationDuration: Double
    let width: CGFloat
    let color: UIColor?
    
    public init(count: Int, animationDuration: Double, width: CGFloat, color: UIColor?) {
        self.count = count
        self.animationDuration = animationDuration
        self.width = width
        self.color = color
    }
}
