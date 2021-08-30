//
//  TouchingThreePointsResult.swift
//  TimeToucher
//
//  Created by Nikolas on 31.08.2021.
//

import Foundation
import UIKit

internal enum TouchingThreePointsResult {
    case circle(center: CGPoint, radius: CGFloat)
    case invalid
}
