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

    public lazy var arcsSetup: ASTimeToucher = {
        
        let secondLine = LTimeToucher(count: 10, animationDuration: 0.1, width: 8)
        let secondArc = ATimeToucher(percentage: 40, lineWidth: 20, radius: 20, startDegree: 0, color: .random, backgroundColor: .lightGray, animationDuration: 10, animationLineSetup: secondLine)
        
        let minuteLine = LTimeToucher(count: 10, animationDuration: 0.1, width: 8)
        let minuteArc = ATimeToucher(percentage: 40, lineWidth: 20, radius: 50, startDegree: 70, color: .random, backgroundColor: .lightGray,  animationDuration: 20, animationLineSetup: minuteLine)
        
        let hourLine = LTimeToucher(count: 10, animationDuration: 0.1, width: 8)
        let hourArc = ATimeToucher(percentage: 40, lineWidth: 20, radius: 80, startDegree: 180, color: .random,backgroundColor: .lightGray,  animationDuration: 30, animationLineSetup: hourLine)
        
        return ASTimeToucher(secondArc: secondArc, minuteArc: minuteArc, hourArc: hourArc)
    }()
    
    public func animateArcs(){
        self.isMultipleTouchEnabled = true
        
        for arc in arcsSetup.directory{
            let arcShapeLayer = TimeToucherDraw.arc(center: CGPoint(x: frame.size.width/2, y: frame.size.height/2), arcSetup: arc.value)
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
        let touchAnimationSetup = getTouchAnimateSetup(touches: touches)

        if !checkTouchBounds(touchPoint: touchAnimationSetup.point){
            return
        }
        
        let indexTouchArc = self.layer.sublayers!.enumerated().filter {return $0.element.name == touchAnimationSetup.arcName}.first!.offset
        self.layer.sublayers![indexTouchArc].removeAllAnimations()

        animateLines(touchAnimationSetup: touchAnimationSetup)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchAnimationSetup = getTouchAnimateSetup(touches: touches)
        
        if !checkTouchBounds(touchPoint: touchAnimationSetup.point){
            return
        }
    
        animateArcTouches(touchAnimationSetup: touchAnimationSetup)
        animateLines(touchAnimationSetup: touchAnimationSetup)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.layer.sublayers?.removeSubrange(6...)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.layer.sublayers?.removeSubrange(6...)
    }
    
    private func animateLines(touchAnimationSetup: TouchAnimationSetup){
        let arrayFrontArc = TimeToucherCalculation.arrayFrontTouchArc(touchPoint: touchAnimationSetup.point, circleCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), circleRadius: touchAnimationSetup.arc.radius + touchAnimationSetup.arc.lineWidth / 2, countPoint: touchAnimationSetup.arc.animationLineSetup.count)
        
        for frontPoint in arrayFrontArc{
            let random2Points = TimeToucherCalculation.random2PointsOnLine(start: frontPoint, end: touchAnimationSetup.point)
            let lineShapeLayer = TimeToucherDraw.line(start: random2Points.0, end: random2Points.1, linesSetup: touchAnimationSetup.arc.animationLineSetup)
            let lineAnimation = TimeToucherAnimation.line(lineSetup:touchAnimationSetup.arc.animationLineSetup)
            lineShapeLayer.add(lineAnimation, forKey: nil)
            self.layer.addSublayer(lineShapeLayer)
        }
    }
    
    private func animateArcTouches(touchAnimationSetup: TouchAnimationSetup){
        let indexTouchArc = self.layer.sublayers!.enumerated().filter {return $0.element.name == touchAnimationSetup.arcName}.first!.offset
        let currentArcTransform: CATransform3D = self.layer.sublayers![indexTouchArc].presentation()!.transform
        
        let toAngle = TimeToucherCalculation.getRotateArcAngle(currentArcTransform: currentArcTransform, touchAnimationSetup: touchAnimationSetup)
    
        let rotationTransform = TimeToucherAnimation.touchesArc(toAngle: toAngle)
        self.layer.sublayers![indexTouchArc].transform = rotationTransform
    }
}

private extension TimeToucher{
    
    func getTouchAnimateSetup(touches: Set<UITouch>) -> TouchAnimationSetup {
        let touchesLocation = touches.map { return $0.location(in: self)}
        var touchPoint = touchesLocation.first!
        var touchArc = arcsSetup.secondArc
        var touchArcName = "secondArc"
        
        switch touches.count {
        case 3:
            guard let touchCenter = TimeToucherCalculation.circleCenterTouch3Point(a: touchesLocation[0], b: touchesLocation[1], c: touchesLocation[2]) else {
                fallthrough
            }
            touchArc = arcsSetup.hourArc
            touchArcName = "hourArc"
            touchPoint = touchCenter
        case 2:
            touchArc = arcsSetup.minuteArc
            touchArcName = "minuteArc"
            touchPoint = TimeToucherCalculation.circleCenterTouch2Point(a: touchesLocation[0], b: touchesLocation[1])
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
}


