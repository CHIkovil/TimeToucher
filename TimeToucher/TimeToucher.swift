//
//  TimeToucher.swift
//  TimeToucher
//
//  Created by Nikolas on 26.08.2021.
//

import Foundation
import UIKit

public protocol TimeToucherDelegate:NSObjectProtocol {
    func timeMoved(timeToSeconds: Int)
}

public final class TimeToucher: UIView {
    let name = "TimeToucher"
    
    //MARK: public user block
    weak public var delegate: TimeToucherDelegate?
        
    /*This method:
    1) create 6 circle arcs(TimeToucherDrawing.arc() give 2 default arcs full background and part time)
    2) add infinity rotate animation for time arcs*/
    public func animateArcs(setup: ASTimeToucher){
        self.setup = setup
        self.isMultipleTouchEnabled = true
        
        for arc in setup.directory{
            let shapeLayers = TimeToucherDrawing.arc(name: arc.key, setup: arc.value, bounds: self.bounds, center: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2))
            
            let animation = TimeToucherAnimation.infinityArcRotate(setup: arc.value)
            shapeLayers.time.add(animation, forKey: arc.key)
            
            self.layer.addSublayer(shapeLayers.background)
            self.layer.addSublayer(shapeLayers.time)
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let points = touches.map {return $0.location(in: self)}
        switchTouches(points: points)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let points = touches.map {return $0.location(in: self)}
        switchTouches(points: points)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        switchTouches(points: nil)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        switchTouches(points: nil)
    }
    
    //MARK: internal main block
    var setup: ASTimeToucher?
    var currentTouchAnimationSetup: TouchAnimationSetup?
    var timeFormat: TimeFormat = {
        return TimeFormat(seconds: 0, minutes: 0, hours: 0)
    }()
    
    /*This method:
    1) set touch reaction
    2) check touch bounds */
    func switchTouches(points: [CGPoint]?){
        guard let setup = setup else {return}
        if checkTouchesNotCorrect(points: points){
            return
        }
        let newTouchAnimationSetup = touchAnimationSetup(points: points!, setup: setup)
        if checkNewTouchNotInBounds(touchPoint: newTouchAnimationSetup.point, setup: setup) {
            rebootArcAnimation(touchAnimationSetup: newTouchAnimationSetup)
        }else{
            animateArcTouches(touchAnimationSetup: newTouchAnimationSetup)
            animateLines(touchAnimationSetup: newTouchAnimationSetup)
            setTime(touchAnimationSetup: newTouchAnimationSetup)
        }
    }
}

//MARK: internal extension
extension TimeToucher{
    
    //MARK: checkTouchesNotCorrect
    /*This method:
    1) check points for cases
    */
    func checkTouchesNotCorrect(points: [CGPoint]?) -> Bool{
        switch points {
        case let points?:
            if points.count > 3{
                fallthrough
            }
            if let currentTouchAnimationSetup = currentTouchAnimationSetup{
                if currentTouchAnimationSetup.pointsCount != points.count{
                    fallthrough
                }
            }
        default:
            if let currentTouchAnimationSetup = currentTouchAnimationSetup{
                rebootArcAnimation(touchAnimationSetup: currentTouchAnimationSetup)
            }
            return true
        }
        return false
    }
    
    //MARK: touchAnimationSetup
    /*This method:
    1) calculation touch center if 3 or 2 touches
    2) gives unified animation setting for other methods  */
    func touchAnimationSetup(points: [CGPoint], setup: ASTimeToucher) -> TouchAnimationSetup {
        var touchPoint = points.first!
        var touchArc = setup.secondArc
        var touchArcName = "secondArc"
        var pointsCount = 1
        
        switch points.count {
        case 3:
            guard let touchCenter = TimeToucherCalculation.circleCenter3TouchPoint(a: points[0], b: points[1], c: points[2]) else {
                fallthrough
            }
            touchArc = setup.hourArc
            touchArcName = "hourArc"
            touchPoint = touchCenter
            pointsCount = 3
        case 2:
            touchArc = setup.minuteArc
            touchArcName = "minuteArc"
            touchPoint = TimeToucherCalculation.circleCenter2TouchPoint(a: points[0], b: points[1])
            pointsCount = 2
        default:break
        }
        
        let indexTouchArc = self.layer.sublayers!.enumerated().filter {return $0.element.name == touchArcName}.first!.offset
        return TouchAnimationSetup(point: touchPoint, arc: touchArc, arcName: touchArcName, circleCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), arcIndex: indexTouchArc, pointsCount: pointsCount)
    }

    //MARK: checkTouchNotInBounds
    /*This method:
    1) get specifications max arc
    2) check max arc contains touch point */
    func checkNewTouchNotInBounds(touchPoint: CGPoint, setup :ASTimeToucher) -> Bool {
        let arcName = setup.maxArc.name
        let arcRadius = setup.maxArc.value.radius
        let arcLineWidth = setup.maxArc.value.lineWidth
        
        let arcsCenter:CGPoint = (self.layer.sublayers?.filter({$0.name == arcName}).first!.position)!
        
        return TimeToucherCalculation.checkCircleContainsPoint(point: touchPoint, circleCenter: arcsCenter, circleRadius: arcRadius + arcLineWidth / 2) || !self.bounds.contains(touchPoint)
    }
    
    //MARK: rebootArcAnimation
    /*This method:
    1) reboot time arc rotate animation (when going beyond the borders and touches event ended,cancelled) */
    func rebootArcAnimation(touchAnimationSetup: TouchAnimationSetup){
        self.layer.sublayers?.removeSubrange(6...)
        let currentArcTransform = self.layer.sublayers![touchAnimationSetup.arcIndex].presentation()?.transform
        let toAngle = TimeToucherCalculation.rotateArcAngle(currentArcTransform: currentArcTransform, touchAnimationSetup: touchAnimationSetup, isTouch: false)
        let rotationTransform = TimeToucherAnimation.rotateArc(toAngle: toAngle)
        self.layer.sublayers![touchAnimationSetup.arcIndex].transform = rotationTransform
        
        let animation = TimeToucherAnimation.infinityArcRotate(setup: touchAnimationSetup.arc)
        self.layer.sublayers![touchAnimationSetup.arcIndex].add(animation, forKey: touchAnimationSetup.arcName)
        
        self.currentTouchAnimationSetup = nil
    }
    
    //MARK: animateArcTouches
    /*This method:
    1) set transform rotation for time arc (move time arc after touch) */
    func animateArcTouches(touchAnimationSetup: TouchAnimationSetup){
        self.layer.sublayers![touchAnimationSetup.arcIndex].removeAllAnimations()
        let currentArcTransform = self.layer.sublayers![touchAnimationSetup.arcIndex].presentation()?.transform
        
        let toAngle = TimeToucherCalculation.rotateArcAngle(currentArcTransform: currentArcTransform, touchAnimationSetup: touchAnimationSetup, isTouch: true)
        
        let rotationTransform = TimeToucherAnimation.rotateArc(toAngle: toAngle)
        self.layer.sublayers![touchAnimationSetup.arcIndex].transform = rotationTransform
        self.currentTouchAnimationSetup = touchAnimationSetup
    }
    
    //MARK: animateLines
    /*This method:
    1) get calculation front arc points array between 2 tangency points of touch point
    2) get calculation random 2 points on line between points front arc and touch point)
    3) set line between 2 random points
    4) add show animation for lines*/
    func animateLines(touchAnimationSetup: TouchAnimationSetup){
        let arrayFrontArc = TimeToucherCalculation.frontArcArray(touchPoint: touchAnimationSetup.point, circleCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), circleRadius: touchAnimationSetup.arc.radius + touchAnimationSetup.arc.lineWidth / 2, amountPoints: touchAnimationSetup.arc.animationLineSetup.count)
        
        for frontPoint in arrayFrontArc{
            let random2Points = TimeToucherCalculation.random2PointOnLine(start: frontPoint, end: touchAnimationSetup.point)
      
            let shapeLayer = TimeToucherDrawing.line(start: random2Points.0, end: random2Points.1, setup: touchAnimationSetup.arc.animationLineSetup)
            
            let animation = TimeToucherAnimation.line(setup: touchAnimationSetup.arc.animationLineSetup)
            
            shapeLayer.add(animation, forKey: nil)
            self.layer.addSublayer(shapeLayer)
        }
    }
    
    //MARK: setTime
    /*This method:
    1) gives for delegate all set time in seconds */
    func setTime(touchAnimationSetup: TouchAnimationSetup){
        var touchAngle = TimeToucherCalculation.angleToPoint(touchPoint: touchAnimationSetup.point, circleCenter: touchAnimationSetup.circleCenter) + 90
        
        let item = touchAngle
        touchAngle = touchAngle >= 360 ? touchAngle - 360 : item
        
        if ["secondArc", "minuteArc"].contains(touchAnimationSetup.arcName)
        {
            let timeNumber = Int(touchAngle) / 6
              
            if touchAnimationSetup.arcName == "secondArc"{
                timeFormat.seconds = timeNumber
            }else{
                timeFormat.minutes = timeNumber
            }
        }else{
            let timeNumber = Int(touchAngle) / 15
            
            timeFormat.hours = timeNumber
        }
        
        self.delegate?.timeMoved(timeToSeconds: timeFormat.seconds + timeFormat.minutes * 60 + timeFormat.hours * 3600)
    }
}
