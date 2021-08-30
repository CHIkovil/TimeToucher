//
//  TimeToucherCalculation.swift
//  TimeToucher
//
//  Created by Nikolas on 28.08.2021.
//

import Foundation
import UIKit

internal class TimeToucherCalculation {
    static func getArrayTouchFrontArc(touchPoint: CGPoint, circleCenter: CGPoint, circleRadius: CGFloat, countPoint: Int) -> [CGPoint]{
        let distanceBetweenCirclesCenter = touchPoint.distance(to: circleCenter)
        
        let distanceToCircleTangencyPoint = getDistanceToCircleTangencyPoint(distanceCirclesCenter:distanceBetweenCirclesCenter, circleRadius: circleRadius)
        
        let twoTangencyPoint = getTwoTangencyPointArray(distanceBetweenCirclesCenter: distanceBetweenCirclesCenter, timeCircleRadius: circleRadius, touchCircleRadius: distanceToCircleTangencyPoint, touchPoint: touchPoint, timeCircleCenter: circleCenter)
        
        let anglesTwoTangencyPoint = twoTangencyPoint.map({getAngleToPoint(touchPoint: $0, circleCenter: circleCenter)})
        
        let arrayFrontArc = getFrontArcArray(anglesTwoTangencyPoint: anglesTwoTangencyPoint, countPoint: countPoint, circleRadius: circleRadius, circleCenter: circleCenter)
        
        return arrayFrontArc
    }
    
    static func checkCircleContainsPoint(point: CGPoint, circleCenter: CGPoint, circleRadius: CGFloat) -> Bool{
        return sqrt(pow(point.x - circleCenter.x, 2) + pow(point.y - circleCenter.y, 2)) < circleRadius
    }
    
}

private extension TimeToucherCalculation {
    static func getDistanceToCircleTangencyPoint(distanceCirclesCenter: CGFloat, circleRadius: CGFloat) -> CGFloat {
        return sqrt(pow(distanceCirclesCenter, 2) - pow(circleRadius, 2))
    }
    
    static func getTwoTangencyPointArray(distanceBetweenCirclesCenter: CGFloat, timeCircleRadius: CGFloat, touchCircleRadius: CGFloat, touchPoint: CGPoint, timeCircleCenter: CGPoint) -> [CGPoint]{
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
    
    static func getFrontArcArray(anglesTwoTangencyPoint: [CGFloat], countPoint: Int, circleRadius: CGFloat, circleCenter: CGPoint) -> [CGPoint] {
        
        let startAngle = anglesTwoTangencyPoint[0]
        var endAngle = anglesTwoTangencyPoint[1]
        
        if startAngle < CGFloat(360) && startAngle > CGFloat(180) {
            endAngle += 360
        }
        
        let angleStep = (abs(endAngle - startAngle) / CGFloat(countPoint)).rounded(.down)
       
        var points: [CGPoint] = []
        var angle = startAngle + angleStep
        
        while angle < endAngle{
            let radians = angle * CGFloat.pi / 180
            let x = circleCenter.x + circleRadius * cos(radians)
            let y = circleCenter.y + circleRadius * sin(radians)
            points.append(CGPoint(x: x, y: y))
            angle += angleStep
        }
        
        return points
    }
    
   static func getAngleToPoint(touchPoint:CGPoint, circleCenter: CGPoint) -> CGFloat{
        let dx =  circleCenter.x - touchPoint.x
        let dy =  circleCenter.y - touchPoint.y
        let radians = atan2(dy, dx) + CGFloat.pi
        
        let degree = radians * (180 / CGFloat.pi)
        return degree
    }
}

private extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}
