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
        let distanceCirclesCenter = touchPoint.distance(to: circleCenter)
        let distanceToCircleTangencyPoint = getDistanceToCircleTangencyPoint(distanceCirclesCenter:distanceCirclesCenter, circleRadius: circleRadius)
        let twoTangencyPoint = getTwoTangencyPoint(distanceCirclesCenter: distanceCirclesCenter, timeCircleRadius: circleRadius, touchCircleRadius: distanceToCircleTangencyPoint, touchPoint: touchPoint, circleCenter: circleCenter)
//        let arrayFrontArc = getArrayFrontArc(twoTangencyPoint: twoTangencyPoint, countPoint: countPoint)
//
//        return arrayFrontArc
        return [twoTangencyPoint.0, twoTangencyPoint.1]
    }
    

}

private extension TimeToucherCalculation {
    static func getDistanceToCircleTangencyPoint(distanceCirclesCenter: CGFloat, circleRadius: CGFloat) -> CGFloat {
        return sqrt(pow(distanceCirclesCenter, 2) - pow(circleRadius, 2))
    }
    
    static func getTwoTangencyPoint(distanceCirclesCenter: CGFloat, timeCircleRadius: CGFloat, touchCircleRadius: CGFloat, touchPoint: CGPoint, circleCenter: CGPoint) -> (CGPoint, CGPoint){
        let distanceToLineOfIntersection = (pow(timeCircleRadius,2) - pow(touchCircleRadius, 2) + pow(distanceCirclesCenter, 2)) / (2 * distanceCirclesCenter)
        let halfLineOfIntersection = sqrt(pow(timeCircleRadius,2) - pow(distanceToLineOfIntersection, 2))
        
        let lineOfIntersectionPointX = circleCenter.x + distanceToLineOfIntersection * (touchPoint.x - circleCenter.x) / distanceCirclesCenter
        let lineOfIntersectionPointY = circleCenter.y + distanceToLineOfIntersection * (touchPoint.y - circleCenter.y) / distanceCirclesCenter
        
        let tangencyPointOneX = lineOfIntersectionPointX + halfLineOfIntersection * (touchPoint.y - circleCenter.y) / distanceCirclesCenter
        let tangencyPointOneY = lineOfIntersectionPointY - halfLineOfIntersection * (touchPoint.x - circleCenter.x) / distanceCirclesCenter
        
        let tangencyPointOne = CGPoint(x: tangencyPointOneX, y: tangencyPointOneY)
        
        let tangencyPointTwoX = lineOfIntersectionPointX - halfLineOfIntersection * (touchPoint.y - circleCenter.y) / distanceCirclesCenter
        let tangencyPointTwoY = lineOfIntersectionPointY + halfLineOfIntersection * (touchPoint.x - circleCenter.x) / distanceCirclesCenter
        
        let tangencyPointTwo = CGPoint(x: tangencyPointTwoX, y: tangencyPointTwoY)
        
        return (tangencyPointOne, tangencyPointTwo)
    }
    
    static func getArrayFrontArc(twoTangencyPoint: (one: CGPoint, second:CGPoint) , countPoint: Int) -> [CGPoint] {
        let a = twoTangencyPoint.one.x - twoTangencyPoint.second.x
        let b = twoTangencyPoint.one.y - twoTangencyPoint.second.y
        let angleStep = Double.pi / Double(countPoint + 1)
        var angle = angleStep
        var points: [CGPoint] = []
        while angle < Double.pi {
            let x = a * CGFloat(cos(angle))
            let y = twoTangencyPoint.one.y - b * CGFloat(sin(angle))
            points.append(CGPoint(x: x, y: y))
            angle += angleStep
        }
        return points
    }
}

private extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}
