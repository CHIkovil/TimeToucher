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
        // given
        let secondLine = LTimeToucher(count: 10, animationDuration: 0.1, width: 8, color: nil)
        let secondArc = ATimeToucher(percentage: 40, lineWidth: 20, radius: 30, startDegree: 0, color: .lightGray, backgroundColor: UIColor(red: 220 / 255, green: 220 / 255, blue: 220 / 255, alpha: 1), animationDuration: 6, animationLineSetup: secondLine)
        
        let minuteLine = LTimeToucher(count: 10, animationDuration: 0.1, width: 8, color: nil)
        let minuteArc = ATimeToucher(percentage: 40, lineWidth: 30, radius: 60, startDegree: 70, color: .lightGray, backgroundColor: UIColor(red: 220 / 255, green: 220 / 255, blue: 220 / 255, alpha: 1),  animationDuration: 4, animationLineSetup: minuteLine)
        
        let hourLine = LTimeToucher(count: 10, animationDuration: 0.1, width: 8, color: nil)
        let hourArc = ATimeToucher(percentage: 40, lineWidth: 40, radius: 100, startDegree: 180, color: .lightGray, backgroundColor: UIColor(red: 220 / 255, green: 220 / 255, blue: 220 / 255, alpha: 1),  animationDuration: 2, animationLineSetup: hourLine)

        let setup = ASTimeToucher(secondArc: secondArc, minuteArc: minuteArc, hourArc: hourArc)
        
        // when
        timeToucher.animateArcs(setup: setup)

        // then
        XCTAssertNotNil(timeToucher.layer.sublayers, "sublayers must be not-nil")
        XCTAssertEqual(timeToucher.layer.sublayers!.count, 6)
        
        let animationSublayers = timeToucher.layer.sublayers!.filter { !($0.animationKeys()?.isEmpty ?? true)}
        XCTAssertEqual(animationSublayers.count, 3)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
