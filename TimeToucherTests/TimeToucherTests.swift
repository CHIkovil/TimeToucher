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
    
    // given
    // when
    // then
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
    
    func testSwitchTouchesIf1TouchInBoundsForTouches() {
        // given
        let point = CGPoint(x: 10, y: 10)
        timeToucher.bounds = CGRect(x: 0, y: 0, width: 400, height: 400)
        
        // when
        timeToucher.animateArcs(setup: setup)
        timeToucher.switchTouches(isReboot: false, points: [point])
        
        // then
        XCTAssertTrue(timeToucher.timeFormat.seconds != 0, "point(one touch) in touch bounds but seconds timer not moved")
    }
    
    func testSwitchTouchesIf1TouchInTimeCirclesCenter() {
        // given
        let point = CGPoint(x: 200, y: 200)
        
        // when
        timeToucher.animateArcs(setup: setup)
        timeToucher.switchTouches(isReboot: false, points: [point])
        
        // then
        XCTAssertTrue(timeToucher.timeFormat.seconds == 0, "point(one touch) in center time circles but seconds timer moved")
    }
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
