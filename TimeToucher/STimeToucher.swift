//
//  STimeToucher.swift
//  TimeToucher
//
//  Created by Nikolas on 27.08.2021.
//

import Foundation

public struct STimeToucher {
    let secondArc: ATimeToucher
    let minuteArc: ATimeToucher
    let hourArc: ATimeToucher
    
    internal var array: [ATimeToucher] {
        return [ secondArc, minuteArc, hourArc]
    }
}
