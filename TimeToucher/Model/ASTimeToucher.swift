//
//  STimeToucher.swift
//  TimeToucher
//
//  Created by Nikolas on 27.08.2021.
//

import Foundation

public struct ASTimeToucher {
    let secondArc: ATimeToucher
    let minuteArc: ATimeToucher
    let hourArc: ATimeToucher
    
    internal var directory: [String:ATimeToucher] {
        return [ "secondArc" : secondArc, "minuteArc" : minuteArc, "hourArc" : hourArc]
    }
}

internal typealias ArcsDirectory = [String:ATimeToucher]
