//
//  TimeToucherTests.swift
//  TimeToucherTests
//
//  Created by Nikolas on 25.08.2021.
//

import XCTest
@testable import TimeToucher

  class TimeToucherTests: XCTestCase {
    
    var timeToucher: TimeToucher!
  
    let setup: ASTimeToucher = {
        let secondLine = LTimeToucher(count: 10, animationDuration: 0.1, width: 8, color: nil)
        let secondArc = ATimeToucher(percentage: 40, lineWidth: 20, radius: 30, startDegree: 0, color: .lightGray, backgroundColor: UIColor(red: 220 / 255, green: 220 / 255, blue: 220 / 255, alpha: 1), animationDuration: 6, animationLineSetup: secondLine)
        
        let minuteLine = LTimeToucher(count: 10, animationDuration: 0.1, width: 8, color: nil)
        let minuteArc = ATimeToucher(percentage: 40, lineWidth: 30, radius: 60, startDegree: 70, color: .lightGray, backgroundColor: UIColor(red: 220 / 255, green: 220 / 255, blue: 220 / 255, alpha: 1),  animationDuration: 4, animationLineSetup: minuteLine)
        
        let hourLine = LTimeToucher(count: 10, animationDuration: 0.1, width: 8, color: nil)
        let hourArc = ATimeToucher(percentage: 40, lineWidth: 40, radius: 100, startDegree: 180, color: .lightGray, backgroundColor: UIColor(red: 220 / 255, green: 220 / 255, blue: 220 / 255, alpha: 1),  animationDuration: 2, animationLineSetup: hourLine)
        
        let setup = ASTimeToucher(secondArc: secondArc, minuteArc: minuteArc, hourArc: hourArc)
        
        return setup
    }()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        timeToucher = TimeToucher()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        timeToucher = nil
        try super.tearDownWithError()
    }
    
 
    func testAnimateArcs() throws {
        // when
        timeToucher.animateArcs(setup: setup)
        
        // then
        XCTAssertNotNil(timeToucher.layer.sublayers, "sublayers must be not-nil")
        
        let sublayers = timeToucher.layer.sublayers!
        XCTAssertEqual(sublayers.count, 6, "count all sublayers must be 6")
        
        let frontSublayerNames = setup.directory.keys
        let frontSublayers = sublayers.filter {frontSublayerNames.contains($0.name ?? "")}
        XCTAssertEqual(frontSublayerNames.count, 3, "every name front sublayer must be exist and contains in keys setup directory ")
        
        let animationFrontSublayers = frontSublayers.filter { !($0.animationKeys()?.isEmpty ?? true)}
        XCTAssertEqual(animationFrontSublayers.count, 3, "in every 3 front arcs must added at least 1 animation")
    }
    
    func testTouches() {
        // given
        let touches = Set([UITouch()])
        // when
        timeToucher.touchesBegan(touches, with: nil)
        timeToucher.touchesMoved(touches, with: nil)
        timeToucher.touchesCancelled(touches, with: nil)
        timeToucher.touchesEnded(touches, with: nil)
    }
      
      func testSwitchTouchesIfRebootCurrentTouchAnimationSetup() {
          // given
          let currentTouchAnimationSetup = TouchAnimationSetup(point: CGPoint(), arc: setup.secondArc, arcName: "", circleCenter: CGPoint(), arcIndex: 0, pointsCount: 1)
    
          // when
          timeToucher.animateArcs(setup: setup)
          timeToucher.currentTouchAnimationSetup = currentTouchAnimationSetup
          timeToucher.switchTouches(points: nil)
          
          // then
          XCTAssertTrue(timeToucher.currentTouchAnimationSetup == nil, "not nil currentTouchAnimationSetup")
      }
    
    func testSwitchTouchesIf1TouchInBoundsForTouches() {
        // given
        let point = CGPoint(x: 10 , y: 10)
        let bounds = CGRect(x: 0, y: 0, width: 400, height: 400)
        
        // when
        timeToucher.bounds = bounds
        timeToucher.animateArcs(setup: setup)
        timeToucher.switchTouches(points: [point])
        
        // then
        XCTAssertTrue(timeToucher.timeFormat.seconds != 0, "point(one touch) in bounds for touches but seconds timer not moved")
    }
    
    func testSwitchTouchesIf1TouchOutBoundsForTouches() {
        // given
        let centerPoint = CGPoint(x: 200, y: 200)
        let outPoint = CGPoint(x: -10, y: -10)
        let bounds = CGRect(x: 0, y: 0, width: 400, height: 400)
        
        // when
        timeToucher.bounds = bounds
        timeToucher.animateArcs(setup: setup)
        timeToucher.switchTouches(points: [centerPoint])
        timeToucher.switchTouches(points: [outPoint])
        
        // then
        XCTAssertTrue(timeToucher.timeFormat.seconds == 0, "point(one touch) out bounds for touches but seconds timer moved")
    }
    
    func testSetTimeIf1TouchAngleMore360() {
        
        let arcDirectory = setup.directory
        for name in arcDirectory.keys {
            // given
            let touchAnimationSetup = TouchAnimationSetup(point: CGPoint(x: 390, y: 10), arc: arcDirectory[name]!, arcName: name, circleCenter: CGPoint(x: 200, y: 200), arcIndex: 1, pointsCount: 1)
            
            // when
            timeToucher.setTime(touchAnimationSetup: touchAnimationSetup)
        }
        
        // then
        XCTAssertTrue((0...25).contains(timeToucher.timeFormat.seconds) && (0...25).contains(timeToucher.timeFormat.minutes) && (0...6).contains(timeToucher.timeFormat.hours), "angle more 360 but angle not reset")
    }
    
    func testAnimationSetupForMore1Touch() {
        // given
        let points3 = [CGPoint](repeating: CGPoint(), count: 3).map { _ in return CGPoint(x: .random(in: 380...400), y: .random(in: 0...20))
        }
    
        // when
        timeToucher.animateArcs(setup: setup)
        let touchAnimationSetupFor2Touches = timeToucher.touchAnimationSetup(points: Array(points3[0..<2]), setup: setup)
        let touchAnimationSetupFor3Touches = timeToucher.touchAnimationSetup(points: points3, setup: setup)
        
        // then
        XCTAssertTrue(touchAnimationSetupFor2Touches.arcName == "minuteArc", "not action case for calculation 2 touch center")
        XCTAssertTrue(touchAnimationSetupFor3Touches.arcName == "hourArc", "not action case for calculation 3 touch center")
    }
    
    func testAnimationSetupIf3TouchCenterNotCalculation(){
        // given
        let points3 = [CGPoint](repeating: CGPoint(x: 380, y: 20), count: 3)
        
        // when
        timeToucher.animateArcs(setup: setup)
        let touchAnimationSetupFor3Touches = timeToucher.touchAnimationSetup(points: points3, setup: setup)
        
        // then
        XCTAssertTrue(touchAnimationSetupFor3Touches.arcName == "minuteArc", "the calculation is not replaced by the calculation of the center for two touches")
    }
    
    func testDrawingLine() {
        // given
        let setup = LTimeToucher(count: 10, animationDuration: 0.1, width: 8, color: .lightGray)
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x: 10, y: 10)
        
        // when
        let shapeLayer = TimeToucherDrawing.line(start: startPoint, end: endPoint, setup: setup)
        
        // then
        XCTAssertTrue(shapeLayer.strokeColor == UIColor.lightGray.cgColor, "personal color for line not setted")
    }
    
    func testGetRotateArcAngleIfNotNilTransformArg() {
        // given
        var transform = CATransform3D()
        transform.m11 = 0.1
        transform.m12 = 0.2
        
        let points3 = [CGPoint](repeating: CGPoint(x: 380, y: 20), count: 3)
        
        // when
        timeToucher.animateArcs(setup: setup)
        let touchAnimationSetupFor3Touches = timeToucher.touchAnimationSetup(points: points3, setup: setup)
        
        let _ = TimeToucherCalculation.rotateArcAngle(currentArcTransform: CATransform3D(), touchAnimationSetup: touchAnimationSetupFor3Touches, isTouch: true)
        let _ = TimeToucherCalculation.rotateArcAngle(currentArcTransform: transform, touchAnimationSetup: touchAnimationSetupFor3Touches, isTouch: false)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // given
    // when
    // then
}
