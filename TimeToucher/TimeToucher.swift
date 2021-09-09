//
//  TimeToucher.swift
//  TimeToucher
//
//  Created by Nikolas on 26.08.2021.
//

import Foundation
import UIKit

public protocol TimeToucherDelegate:NSObjectProtocol {
    func timeMoved(formatTime: String)
}

public final class TimeToucher: UIView {
    let name = "TimeToucher"
    
    weak public var delegate: TimeToucherDelegate?
    
    public lazy var arcsSetup: ASTimeToucher = {
        
        let secondLine = LTimeToucher(count: 10, animationDuration: 0.1, width: 8)
        let secondArc = ATimeToucher(percentage: 40, lineWidth: 20, radius: 30, startDegree: 0, color: .random, backgroundColor: UIColor(red: 220 / 255, green: 220 / 255, blue: 220 / 255, alpha: 1), animationDuration: 6, animationLineSetup: secondLine)
        
        let minuteLine = LTimeToucher(count: 10, animationDuration: 0.1, width: 8)
        let minuteArc = ATimeToucher(percentage: 40, lineWidth: 30, radius: 60, startDegree: 70, color: .random, backgroundColor: UIColor(red: 220 / 255, green: 220 / 255, blue: 220 / 255, alpha: 1),  animationDuration: 4, animationLineSetup: minuteLine)
        
        let hourLine = LTimeToucher(count: 10, animationDuration: 0.1, width: 8)
        let hourArc = ATimeToucher(percentage: 40, lineWidth: 40, radius: 100, startDegree: 180, color: .random,backgroundColor: UIColor(red: 220 / 255, green: 220 / 255, blue: 220 / 255, alpha: 1),  animationDuration: 2, animationLineSetup: hourLine)
        
        return ASTimeToucher(secondArc: secondArc, minuteArc: minuteArc, hourArc: hourArc)
    }()
    
    public func animateArcs(){
        self.isMultipleTouchEnabled = true
        
        for arc in arcsSetup.directory{
            let arcShapeLayer = TimeToucherDrawing.arc(center: CGPoint(x: frame.size.width/2, y: frame.size.height/2), arcSetup: arc.value)
            arcShapeLayer.time.bounds = self.layer.bounds
            arcShapeLayer.time.name = arc.key
            arcShapeLayer.background.name = "back\(arc.key)"
            
            let arcAnimation = TimeToucherAnimation.arc(arcSetup: arc.value)
            arcShapeLayer.time.add(arcAnimation, forKey: arc.key)
            
            self.layer.addSublayer(arcShapeLayer.background)
            self.layer.addSublayer(arcShapeLayer.time)
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switchTouches(touchesName: "Began", touches: touches)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        switchTouches(touchesName: "Moved", touches: touches)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        switchTouches(touchesName: "Cancelled", touches: touches)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        switchTouches(touchesName: "Ended", touches: touches)
    }
    
    private func switchTouches(touchesName: String, touches: Set<UITouch>){
        let touchAnimationSetup = touchAnimationSetup(touches: touches)
        
        let indexTouchArc = self.layer.sublayers!.enumerated().filter {return $0.element.name == touchAnimationSetup.arcName}.first!.offset
        
        if !checkTouchBounds(touchPoint: touchAnimationSetup.point){
            self.layer.sublayers![indexTouchArc].removeAllAnimations()
            let currentArcTransform: CATransform3D = self.layer.sublayers![indexTouchArc].presentation()!.transform
            let currentArcAngle = atan2(currentArcTransform.m12, currentArcTransform.m11)
            self.layer.sublayers![indexTouchArc].transform = CATransform3DMakeRotation(currentArcAngle, 0, 0, 1)
            rebootArcAnimation(indexTouchArc: indexTouchArc, touchAnimationSetup: touchAnimationSetup)
            return
        }
        
        switch touchesName {
        case "Began", "Moved":
            self.layer.sublayers![indexTouchArc].removeAllAnimations()
            animateArcTouches(indexTouchArc: indexTouchArc, touchAnimationSetup: touchAnimationSetup)
            animateLines(touchAnimationSetup: touchAnimationSetup)
            setTime(touchAnimationSetup: touchAnimationSetup)
            return
        case "Cancelled":
            fallthrough
        case "Ended":
            rebootArcAnimation(indexTouchArc: indexTouchArc, touchAnimationSetup: touchAnimationSetup)
        default:
            self.layer.sublayers?.removeSubrange(6...)
        }
    }
}

private extension TimeToucher{
    
    func animateLines(touchAnimationSetup: TouchAnimationSetup){
        let arrayFrontArc = TimeToucherCalculation.arrayFrontTouchArc(touchPoint: touchAnimationSetup.point, circleCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), circleRadius: touchAnimationSetup.arc.radius + touchAnimationSetup.arc.lineWidth / 2, countPoint: touchAnimationSetup.arc.animationLineSetup.count)
        
        for frontPoint in arrayFrontArc{
            let random2Points = TimeToucherCalculation.random2PointsOnLine(start: frontPoint, end: touchAnimationSetup.point)
            let lineShapeLayer = TimeToucherDrawing.line(start: random2Points.0, end: random2Points.1, linesSetup: touchAnimationSetup.arc.animationLineSetup)
            let lineAnimation = TimeToucherAnimation.line(lineSetup:touchAnimationSetup.arc.animationLineSetup)
            lineShapeLayer.add(lineAnimation, forKey: nil)
            self.layer.addSublayer(lineShapeLayer)
        }
    }
    
    func animateArcTouches(indexTouchArc: Int, touchAnimationSetup: TouchAnimationSetup){
        let currentArcTransform: CATransform3D = self.layer.sublayers![indexTouchArc].presentation()!.transform
        
        let toAngle = TimeToucherCalculation.getRotateArcAngle(currentArcTransform: currentArcTransform, touchAnimationSetup: touchAnimationSetup)
        
        let rotationTransform = TimeToucherAnimation.arcTouches(toAngle: toAngle)
        self.layer.sublayers![indexTouchArc].transform = rotationTransform
    }
    
    func rebootArcAnimation(indexTouchArc: Int,  touchAnimationSetup: TouchAnimationSetup){
        let arcSetup = arcsSetup.directory[touchAnimationSetup.arcName]
        let arcAnimation = TimeToucherAnimation.arc(arcSetup: arcSetup!)
        
        self.layer.sublayers![indexTouchArc].add(arcAnimation, forKey: touchAnimationSetup.arcName)
    }
    
    func touchAnimationSetup(touches: Set<UITouch>) -> TouchAnimationSetup {
        let touchesLocation = touches.map { return $0.location(in: self)}
        var touchPoint = touchesLocation.first!
        var touchArc = arcsSetup.secondArc
        var touchArcName = "secondArc"
        
        switch touches.count {
        case 3, 2:
            guard let touchCenter = TimeToucherCalculation.circleCenterTouch3Point(a: touchesLocation[0], b: touchesLocation[1], c: touchesLocation[2]) else {
                touchArc = arcsSetup.minuteArc
                touchArcName = "minuteArc"
                touchPoint = TimeToucherCalculation.circleCenterTouch2Point(a: touchesLocation[0], b: touchesLocation[1])
                break
            }
            touchArc = arcsSetup.hourArc
            touchArcName = "hourArc"
            touchPoint = touchCenter
        default: break
        }
        
        return TouchAnimationSetup(point: touchPoint, arc: touchArc, arcName: touchArcName, circleCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2))
    }
    
    func checkTouchBounds(touchPoint: CGPoint) -> Bool {
        let arcName = arcsSetup.maxArc.name
        let arcRadius = arcsSetup.maxArc.value.radius
        let arcLineWidth = arcsSetup.maxArc.value.lineWidth
        
        let arcsCenter:CGPoint = (self.layer.sublayers?.filter({$0.name == arcName}).first!.position)!
        
        if !TimeToucherCalculation.checkCircleNotContainsPoint(point: touchPoint, circleCenter: arcsCenter, circleRadius: arcRadius + arcLineWidth / 2) || !self.bounds.contains(touchPoint){
            return false
        }
        return true
    }
    
    func setTime(touchAnimationSetup: TouchAnimationSetup){
        var second = "00"
        var minute = "00"
        var hour = "00"
       
        var touchAngle = TimeToucherCalculation.angleToPoint(touchPoint: touchAnimationSetup.point, circleCenter: touchAnimationSetup.circleCenter) + 90
        
        if touchAngle >= 360{
            touchAngle = touchAngle - 360
        }
    
        switch touchAnimationSetup.arcName {
        case "secondArc", "minuteArc":
            var timeNumber = Int(touchAngle) / 6
            if timeNumber == 60 {timeNumber -= 1}
            
            var timeStr = "\(timeNumber)"
            if (timeNumber / 10) == 0 {timeStr = "0" + timeStr}
              
            if touchAnimationSetup.arcName == "secondArc"{
                second = timeStr
            }else{
                minute = timeStr
            }
            
        case "hourArc":
            var timeNumber = Int(touchAngle) / 15
            if timeNumber == 24 {timeNumber -= 1}

            var timeStr = "\(timeNumber)"
            if (timeNumber / 10) == 0 {timeStr = "0" + timeStr}
            
            hour  = timeStr
        default:break
        }
        
        self.delegate?.timeMoved(formatTime: "\(hour):\(minute):\(second)")
    }
    
}


