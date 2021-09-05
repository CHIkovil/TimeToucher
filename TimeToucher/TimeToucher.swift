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
        let secondArc = ATimeToucher(percentage: 40, lineWidth: 20, radius: 20, startDegree: 0, color: .random, backgroundColor: .lightGray, animationDuration: 10, lineSetup: secondLine)
        
        let minuteLine = LTimeToucher(count: 10, animationDuration: 0.1, width: 8)
        let minuteArc = ATimeToucher(percentage: 40, lineWidth: 20, radius: 50, startDegree: 70, color: .random, backgroundColor: .lightGray,  animationDuration: 20, lineSetup: minuteLine)
        
        let hourLine = LTimeToucher(count: 10, animationDuration: 0.1, width: 8)
        let hourArc = ATimeToucher(percentage: 40, lineWidth: 20, radius: 80, startDegree: 180, color: .random,backgroundColor: .lightGray,  animationDuration: 30, lineSetup: hourLine)
        
        return ASTimeToucher(secondArc: secondArc, minuteArc: minuteArc, hourArc: hourArc)
    }()
    
    public func animateArcs(){
        self.isMultipleTouchEnabled = true
        
        for arc in arcsSetup.directory{
            let arcShapeLayer = TimeToucherDraw.arc(center: CGPoint(x: frame.size.width/2, y: frame.size.height/2), arcSetup: arc.value)
            arcShapeLayer.time.bounds = self.layer.bounds
            arcShapeLayer.time.name = arc.key
            arcShapeLayer.background.name = arc.key
            
            let arcAnimation = TimeToucherAnimation.arc(arcSetup: arc.value)
            arcShapeLayer.time.add(arcAnimation, forKey: arc.key)
            
            self.layer.addSublayer(arcShapeLayer.background)
            self.layer.addSublayer(arcShapeLayer.time)
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateLines(touches: touches)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateLines(touches: touches)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.layer.sublayers?.removeSubrange(6...)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.layer.sublayers?.removeSubrange(6...)
    }
    
    private func animateLines(touches: Set<UITouch>){
       
        let animateSetup = getAnimateSetup(touches: touches)

        if !checkTouchBounds(touchPoint: animateSetup.touchPoint){
            return
        }
            
        let arrayFrontArc = TimeToucherCalculation.arrayTouchFrontArc(touchPoint: animateSetup.touchPoint, circleCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), circleRadius: animateSetup.touchArc.radius + animateSetup.touchArc.lineWidth / 2, countPoint: animateSetup.touchArc.lineSetup.count)
        
        for frontPoint in arrayFrontArc{
            let random2Points = TimeToucherCalculation.random2PointsOnLine(start: frontPoint, end: animateSetup.touchPoint)
            let lineShapeLayer = TimeToucherDraw.line(start: random2Points.0, end: random2Points.1, linesSetup: animateSetup.touchArc.lineSetup)
            let lineAnimation = TimeToucherAnimation.line(lineSetup:animateSetup.touchArc.lineSetup)
            lineShapeLayer.add(lineAnimation, forKey: nil)
            self.layer.addSublayer(lineShapeLayer)
        }
    }
}

private extension TimeToucher{

    func getAnimateSetup(touches: Set<UITouch>) -> (touchPoint: CGPoint, touchArc: ATimeToucher) {
        let touchesLocation = touches.map { return $0.location(in: self)}
        var touchPoint = touchesLocation.first!
        var touchArc = arcsSetup.secondArc
        
        switch touches.count {
        case 3:
            guard let touchCenter = TimeToucherCalculation.circleCenterTouch3Point(a: touchesLocation[0], b: touchesLocation[1], c: touchesLocation[2]) else {
                fallthrough
            }
            touchArc = arcsSetup.hourArc
            touchPoint = touchCenter
        case 2:
            touchArc = arcsSetup.minuteArc
            touchPoint = TimeToucherCalculation.circleCenterTouch2Point(a: touchesLocation[0], b: touchesLocation[1])
        default: break
        }
        return (touchPoint, touchArc)
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


