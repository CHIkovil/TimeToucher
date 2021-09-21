//
//  TimeToucherCalculation.swift
//  TimeToucher
//
//  Created by Nikolas on 28.08.2021.
//

import Foundation
import UIKit

class TimeToucherCalculation {
    
    //MARK: frontTouchArcArray
    static func frontTouchArcArray(touchPoint: CGPoint, circleCenter: CGPoint, circleRadius: CGFloat, countPoint: Int) -> [CGPoint]{
        let distanceBetweenCirclesCenter = touchPoint.distance(to: circleCenter)
        
        let distanceToCircleTangencyPoint = distanceToCircleTangencyPoint(distanceBetweenCirclesCenter:distanceBetweenCirclesCenter, circleRadius: circleRadius)
        
        let tangency2PointArray = tangency2PointArray(distanceBetweenCirclesCenter: distanceBetweenCirclesCenter, timeCircleRadius: circleRadius, touchCircleRadius: distanceToCircleTangencyPoint, touchPoint: touchPoint, timeCircleCenter: circleCenter)
        
        let tangencyAngleArray = tangency2PointArray.map({angleToPoint(touchPoint: $0, circleCenter: circleCenter)})
        let anglesTangency2Point = (tangencyAngleArray[0],tangencyAngleArray[1])
        
        let arrayFrontArc = frontArcArray(anglesTangency2Point: anglesTangency2Point, countPoint: countPoint, circleRadius: circleRadius, circleCenter: circleCenter)
        
        return arrayFrontArc
    }
    
    //MARK: checkCircleContainsPoint
    static func checkCircleContainsPoint(point: CGPoint, circleCenter: CGPoint, circleRadius: CGFloat) -> Bool{
        return sqrt(pow(point.x - circleCenter.x, 2) + pow(point.y - circleCenter.y, 2)) < circleRadius
    }
    
    //MARK: circleCenterTouch3Point
    static func circleCenterTouch3Point(a: CGPoint, b: CGPoint, c: CGPoint) -> CGPoint? {
        let d1 = CGPoint(x: b.y - a.y, y: a.x - b.x)
        let d2 = CGPoint(x: c.y - a.y, y: a.x - c.x)
        let k: CGFloat = d2.x * d1.y - d2.y * d1.x
        guard k < -0.00001 || k > 0.00001 else {
            return nil
        }
        let s1 = CGPoint(x: (a.x + b.x) / 2, y: (a.y + b.y) / 2)
        let s2 = CGPoint(x: (a.x + c.x) / 2, y: (a.y + c.y) / 2)
        let l: CGFloat = d1.x * (s2.y - s1.y) - d1.y * (s2.x - s1.x)
        let m: CGFloat = l / k
        let center = CGPoint(x: s2.x + m * d2.x, y: s2.y + m * d2.y)
        return center
    }
    
    //MARK: circleCenterTouch2Point
    static func circleCenterTouch2Point(a: CGPoint, b: CGPoint) -> CGPoint {
        return CGPoint(x: (a.x + b.x) / 2, y: (a.y + b.y) / 2)
    }
    
    //MARK: random2PointsOnLine
    static func random2PointsOnLine(start: CGPoint, end: CGPoint) -> (CGPoint, CGPoint){
        let a = (start.y - end.y)/(start.x - end.x)
        let b = start.y - a * start.x
        
        let random2Numbers = [CGFloat](repeating: CGFloat(), count: 2).map { _ in
            return  start.x < end.x ? CGFloat.random(in: start.x...end.x) : CGFloat.random(in: end.x...start.x)
        }
  
        let random2Points = random2Numbers.map {CGPoint(x: $0, y: a * $0 + b)}
        return (random2Points[0], random2Points[1])
    }
    
    //MARK: angleToPoint
    static func angleToPoint(touchPoint:CGPoint, circleCenter: CGPoint) -> CGFloat{
         let dx =  circleCenter.x - touchPoint.x
         let dy =  circleCenter.y - touchPoint.y
         let radians = atan2(dy, dx) + .pi
         
         let degree = radians * (180 / .pi)
         return degree
     }
    
    //MARK: getRotateArcAngle
    static func getRotateArcAngle(currentArcTransform: CATransform3D?, touchAnimationSetup: TouchAnimationSetup, isTouch: Bool) -> CGFloat {
        guard let currentArcTransform = currentArcTransform else {
            return 0
        }
      
        switch isTouch {
        case true:
            let startArcAngle = touchAnimationSetup.arc.startDegree
            let endArcAngle = touchAnimationSetup.arc.startDegree + 360 * touchAnimationSetup.arc.percentage / 100
            
            let centerArcAngle = (endArcAngle - startArcAngle) / 2
            
            let toAngle =  angleToPoint(touchPoint: touchAnimationSetup.point, circleCenter: touchAnimationSetup.circleCenter) - centerArcAngle
            return toAngle
        default:
            let currentArcRadians = atan2(currentArcTransform.m12, currentArcTransform.m11)
            return currentArcRadians * (180 / .pi)
        }
    }
}

//MARK: extension
private extension TimeToucherCalculation {
    
    
    //MARK: distanceToCircleTangencyPoint
    static func distanceToCircleTangencyPoint(distanceBetweenCirclesCenter: CGFloat, circleRadius: CGFloat) -> CGFloat {
        return sqrt(pow(distanceBetweenCirclesCenter, 2) - pow(circleRadius, 2))
    }
    
    //MARK: tangency2PointArray
    static func tangency2PointArray(distanceBetweenCirclesCenter: CGFloat, timeCircleRadius: CGFloat, touchCircleRadius: CGFloat, touchPoint: CGPoint, timeCircleCenter: CGPoint) -> [CGPoint]{
        let distanceToLineOfIntersection = (pow(timeCircleRadius,2) - pow(touchCircleRadius, 2) + pow(distanceBetweenCirclesCenter, 2)) / (2 * distanceBetweenCirclesCenter)
        let halfLineOfIntersection = sqrt(pow(timeCircleRadius,2) - pow(distanceToLineOfIntersection, 2))
        
        let lineOfIntersectionPointX = timeCircleCenter.x + distanceToLineOfIntersection * (touchPoint.x - timeCircleCenter.x) / distanceBetweenCirclesCenter
        let lineOfIntersectionPointY = timeCircleCenter.y + distanceToLineOfIntersection * (touchPoint.y - timeCircleCenter.y) / distanceBetweenCirclesCenter
        
        let startTangencyPointX = lineOfIntersectionPointX + halfLineOfIntersection * (touchPoint.y - timeCircleCenter.y) / distanceBetweenCirclesCenter
        let startTangencyPointY = lineOfIntersectionPointY - halfLineOfIntersection * (touchPoint.x - timeCircleCenter.x) / distanceBetweenCirclesCenter
        
        let startTangencyPoint = CGPoint(x: startTangencyPointX, y: startTangencyPointY)
        
        let endTangencyPointX = lineOfIntersectionPointX - halfLineOfIntersection * (touchPoint.y - timeCircleCenter.y) / distanceBetweenCirclesCenter
        let endTangencyPointY = lineOfIntersectionPointY + halfLineOfIntersection * (touchPoint.x - timeCircleCenter.x) / distanceBetweenCirclesCenter
        
        let endTangencyPoint = CGPoint(x: endTangencyPointX, y: endTangencyPointY)
        
        return [startTangencyPoint, endTangencyPoint]
    }
    
    //MARK: frontArcArray
    static func frontArcArray(anglesTangency2Point: (start: CGFloat, end: CGFloat), countPoint: Int, circleRadius: CGFloat, circleCenter: CGPoint) -> [CGPoint] {
        
        let startAngle = anglesTangency2Point.start
        let endAngle = anglesTangency2Point.end < anglesTangency2Point.start ? 360 + anglesTangency2Point.end : anglesTangency2Point.end
        
        let angleStep = ((endAngle - startAngle) / CGFloat(countPoint + 1)).rounded(.down)
       
        var points: [CGPoint] = []
        var angle = startAngle + angleStep
        var count = 0
        
        while angle < endAngle && count < countPoint{
            let item = angle
            angle = item >= 360 ? item - 360 : item
            
            let radians = angle * CGFloat.pi / 180
            let x = circleCenter.x + circleRadius * cos(radians)
            let y = circleCenter.y + circleRadius * sin(radians)
            points.append(CGPoint(x: x, y: y))
            angle += angleStep
            count += 1
        }
        
        return points
    }
}

//MARK: extension CGPoint
private extension CGPoint {
    
    
    //MARK: distance
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}
