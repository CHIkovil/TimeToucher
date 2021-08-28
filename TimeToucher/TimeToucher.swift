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
    
    //MARK: public
    public var arcsSetup: STimeToucher?
    
    private func setArcsArray() -> [ATimeToucher] {
        if let setup = arcsSetup{
            return setup.array
        }else{
            let secondArc = ATimeToucher(percentage: 40, lineWidth: 20, radius: 50, startDegree: 0, color: .random, backgroundColor: .lightGray, animateDuration: 10)
            let minuteArc = ATimeToucher(percentage: 40, lineWidth: 30, radius: 100, startDegree: 70, color: .random, backgroundColor: .lightGray,  animateDuration: 20)
            let hourArc = ATimeToucher(percentage: 40, lineWidth: 50, radius: 150, startDegree: 180, color: .random,backgroundColor: .lightGray,  animateDuration: 30)
            
            return STimeToucher(secondArc: secondArc, minuteArc: minuteArc, hourArc: hourArc).array
        }
    }
    
    private func addLayer(arc: ATimeToucher) {
        let aDegree = CGFloat.pi / 180
        
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2),
                                            radius: arc.radius,
                                            startAngle: 0,
                                            endAngle: .pi * 2,
                                            clockwise: true).cgPath
        backgroundLayer.strokeColor = arc.backgroundColor.cgColor
        backgroundLayer.lineWidth = arc.lineWidth
        backgroundLayer.fillColor = UIColor.clear.cgColor
        
        let timeLayer = CAShapeLayer()
        let arcPach = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2),
                                      radius: arc.radius,
                                      startAngle: aDegree * arc.startDegree,
                                      endAngle: aDegree * (arc.startDegree + 360 * arc.percentage / 100),
                                      clockwise: true)
        timeLayer.path = arcPach.cgPath
        timeLayer.strokeColor  = arc.color.cgColor
        timeLayer.lineWidth = arc.lineWidth
        timeLayer.fillColor = UIColor.clear.cgColor
        timeLayer.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        timeLayer.bounds = self.layer.bounds
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.byValue = NSNumber(floatLiteral: Double(CGFloat.pi * 2))
        animation.duration = arc.animateDuration
        animation.repeatCount = .infinity
        
        timeLayer.add(animation, forKey: nil)
        
        self.layer.addSublayer(backgroundLayer)
        self.layer.addSublayer(timeLayer)
    }
    
}

public extension TimeToucher {
    func animateArcs(){
        let arcsArray = setArcsArray()
        for arc in arcsArray{
            addLayer(arc: arc)
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

