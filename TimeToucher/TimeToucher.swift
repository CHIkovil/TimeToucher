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
    
    public var arcsSetup: ASTimeToucher?
    
    public func animateArcs(){
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
}

private extension TimeToucher {
    func getArcsDirectory() -> ArcsDirectory{
        switch arcsSetup{
        case let setup?:
            return setup.directory
            
        default:
            let secondArc = ATimeToucher(percentage: 40, lineWidth: 20, radius: 50, startDegree: 0, color: .random, backgroundColor: .lightGray, animateDuration: 10)
            let minuteArc = ATimeToucher(percentage: 40, lineWidth: 30, radius: 100, startDegree: 70, color: .random, backgroundColor: .lightGray,  animateDuration: 20)
            let hourArc = ATimeToucher(percentage: 40, lineWidth: 50, radius: 150, startDegree: 180, color: .random,backgroundColor: .lightGray,  animateDuration: 30)
            
            return ASTimeToucher(secondArc: secondArc, minuteArc: minuteArc, hourArc: hourArc).directory
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
