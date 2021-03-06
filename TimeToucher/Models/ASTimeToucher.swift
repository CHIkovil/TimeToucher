//
//  STimeToucher.swift
//  TimeToucher
//
//  Created by Nikolas on 27.08.2021.
//

import Foundation
import UIKit

public struct ASTimeToucher {
    let secondArc: ATimeToucher
    let minuteArc: ATimeToucher
    let hourArc: ATimeToucher
    
    public init(secondArc: ATimeToucher, minuteArc: ATimeToucher, hourArc: ATimeToucher) {
        self.secondArc = secondArc
        self.minuteArc = minuteArc
        self.hourArc = hourArc
    }
    
    internal var directory: [String:ATimeToucher] {
        return [ "secondArc" : secondArc, "minuteArc" : minuteArc, "hourArc" : hourArc]
    }
    
    internal var maxArc: (name: String, value: ATimeToucher) {
        let arc = directory.max { $0.value.radius < $1.value.radius}!
        return (arc.key, arc.value)
    }
}
