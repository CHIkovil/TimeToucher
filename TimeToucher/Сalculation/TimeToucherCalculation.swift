//
//  TimeToucherCalculation.swift
//  TimeToucher
//
//  Created by Nikolas on 28.08.2021.
//

import Foundation
import UIKit

class TimeToucherCalculation {
    
    //MARK: frontArcArray
    static func frontArcArray(touchPoint: CGPoint, circleCenter: CGPoint, circleRadius: CGFloat, amountPoints: Int) -> [CGPoint]{
        let distanceBetween2Point = touchPoint.distance(to: circleCenter)
        
        let distanceToCircleTangencyPoint = distanceToCircle2TangencyPoint(distanceBetweenCirclesCenter:distanceBetween2Point, circleRadius: circleRadius)
        
        let array2TangencyPoint = tangency2PointArray(distanceBetweenCirclesCenter: distanceBetween2Point, timeCircleRadius: circleRadius, touchCircleRadius: distanceToCircleTangencyPoint, touchPoint: touchPoint, timeCircleCenter: circleCenter)
        
        let array2TangencyAngle = array2TangencyPoint.map({angleToPoint(touchPoint: $0, circleCenter: circleCenter)})
        let angles2TangencyPoint = (array2TangencyAngle[0],array2TangencyAngle[1])
        
        let arcArray = arcArray(angles2TangencyPoint: angles2TangencyPoint, amountPoints: amountPoints, circleRadius: circleRadius, circleCenter: circleCenter)
        
        return arcArray
    }
    
    //MARK: checkCircleContainsPoint
    static func checkCircleContainsPoint(point: CGPoint, circleCenter: CGPoint, circleRadius: CGFloat) -> Bool{
        return sqrt(pow(point.x - circleCenter.x, 2) + pow(point.y - circleCenter.y, 2)) < circleRadius
    }
    
    //MARK: circleCenter3TouchPoint
    static func circleCenter3TouchPoint(a: CGPoint, b: CGPoint, c: CGPoint) -> CGPoint? {
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
    
    //MARK: circleCenter2TouchPoint
    static func circleCenter2TouchPoint(a: CGPoint, b: CGPoint) -> CGPoint {
        return CGPoint(x: (a.x + b.x) / 2, y: (a.y + b.y) / 2)
    }
    
    //MARK: random2PointOnLine
    static func random2PointOnLine(start: CGPoint, end: CGPoint) -> (CGPoint, CGPoint){
        let a = (start.y - end.y)/(start.x - end.x)
        let b = start.y - a * start.x
        
        let random2Number = [CGFloat](repeating: CGFloat(), count: 2).map { _ in
            return  start.x < end.x ? CGFloat.random(in: start.x...end.x) : CGFloat.random(in: end.x...start.x)
        }
  
        let random2Point = random2Number.map {CGPoint(x: $0, y: a * $0 + b)}
        return (random2Point[0], random2Point[1])
    }
    
    //MARK: angleToPoint
    static func angleToPoint(touchPoint:CGPoint, circleCenter: CGPoint) -> CGFloat{
         let dx =  circleCenter.x - touchPoint.x
         let dy =  circleCenter.y - touchPoint.y
         let radians = atan2(dy, dx) + .pi
         
         let degree = radians * (180 / .pi)
         return degree
     }
    
    //MARK: rotateArcAngle
    static func rotateArcAngle(currentArcTransform: CATransform3D?, touchAnimationSetup: TouchAnimationSetup, isTouch: Bool) -> CGFloat {
        guard let currentArcTransform = currentArcTransform else {
            return 0
        }
      
        switch isTouch {
        case true:
            let centerArcAngle = 360 * touchAnimationSetup.arc.percentage / 200
            
            let toAngle =  angleToPoint(touchPoint: touchAnimationSetup.point, circleCenter: touchAnimationSetup.circleCenter) - centerArcAngle - touchAnimationSetup.arc.startDegree
            return toAngle
        default:
            let currentArcAngle = atan2(currentArcTransform.m12, currentArcTransform.m11)
            return currentArcAngle * (180 / .pi)
        }
    }
}

//MARK: extension
private extension TimeToucherCalculation {
    
    //MARK: distanceToCircle2TangencyPoint
    static func distanceToCircle2TangencyPoint(distanceBetweenCirclesCenter: CGFloat, circleRadius: CGFloat) -> CGFloat {
        return sqrt(pow(distanceBetweenCirclesCenter, 2) - pow(circleRadius, 2))
    }
    
    //MARK: tangency2PointArray
    static func tangency2PointArray(distanceBetweenCirclesCenter: CGFloat, timeCircleRadius: CGFloat, touchCircleRadius: CGFloat, touchPoint: CGPoint, timeCircleCenter: CGPoint) -> [CGPoint]{
        let distanceToLineOfIntersection = (pow(timeCircleRadius,2) - pow(touchCircleRadius, 2) + pow(distanceBetweenCirclesCenter, 2)) / (2 * distanceBetweenCirclesCenter)
        let halfLineOfIntersection = sqrt(pow(timeCircleRadius,2) - pow(distanceToLineOfIntersection, 2))
        
        let lineOfIntersectionPointX = timeCircleCenter.x + distanceToLineOfIntersection * (touchPoint.x - timeCircleCenter.x) / distanceBetweenCirclesCenter
        let lineOfIntersectionPointY = timeCircleCenter.y + distanceToLineOfIntersection * (touchPoint.y - timeCircleCenter.y) / distanceBetweenCirclesCenter
        
        let firstTangencyPointX = lineOfIntersectionPointX + halfLineOfIntersection * (touchPoint.y - timeCircleCenter.y) / distanceBetweenCirclesCenter
        let firstTangencyPointY = lineOfIntersectionPointY - halfLineOfIntersection * (touchPoint.x - timeCircleCenter.x) / distanceBetweenCirclesCenter
        
        let firstTangencyPoint = CGPoint(x: firstTangencyPointX, y: firstTangencyPointY)
        
        let secondTangencyPointX = lineOfIntersectionPointX - halfLineOfIntersection * (touchPoint.y - timeCircleCenter.y) / distanceBetweenCirclesCenter
        let secondTangencyPointY = lineOfIntersectionPointY + halfLineOfIntersection * (touchPoint.x - timeCircleCenter.x) / distanceBetweenCirclesCenter
        
        let secondTangencyPoint = CGPoint(x: secondTangencyPointX, y: secondTangencyPointY)
        
        return [firstTangencyPoint, secondTangencyPoint]
    }
    
    //MARK: arcArray
    static func arcArray(angles2TangencyPoint: (start: CGFloat, end: CGFloat), amountPoints: Int, circleRadius: CGFloat, circleCenter: CGPoint) -> [CGPoint] {
        
        let startAngle = angles2TangencyPoint.start
        let endAngle = angles2TangencyPoint.end < angles2TangencyPoint.start ? 360 + angles2TangencyPoint.end : angles2TangencyPoint.end
        
        let angleStep = ((endAngle - startAngle) / CGFloat(amountPoints + 1)).rounded(.down)
       
        var points: [CGPoint] = []
        var angle = startAngle + angleStep
        var count = 0
        
        while angle < endAngle && count < amountPoints{
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
