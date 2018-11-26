//
//  ANTimerTests.swift
//  ANTimerTests
//
//  Created by 刘栋 on 2018/11/26.
//  Copyright © 2018 anotheren.com. All rights reserved.
//

import XCTest
@testable import ANTimer

class ANTimerTests: XCTestCase {

    func testSingleTimer() {
        
        let expectation = self.expectation(description: "timer fire")
        
        let timer = ANTimer(interval: .seconds(2)) { _ in
            print("timer fire")
            expectation.fulfill()
        }
        timer.start()
        self.waitForExpectations(timeout: 2.01, handler: nil)
    }
    
    func testRepeaticTimer() {
        
        let expectation = self.expectation(description: "timer fire")
        
        var count = 0
        let timer = ANTimer.repeaticTimer(interval: .seconds(1)) { _ in
            count = count + 1
            if count == 2 {
                expectation.fulfill()
            }
        }
        timer.start()
        self.waitForExpectations(timeout: 2.01, handler: nil)
    }
    
    func testTimerAndInternalTimerRetainCycle() {
        
        //let expectation = self.expectation(description: "test deinit")
        var count = 0
        weak var weakReference: ANTimer?
        do {
            let timer = ANTimer.repeaticTimer(interval: .seconds(1)) { _ in
                count += 1
                print(count)
            }
            weakReference = timer
            timer.start()
        }
        XCTAssertNil(weakReference)
    }
    
    func testDebounce() {
        
        let expectation = self.expectation(description: "test debounce")
        
        var count = 0
        let timer = ANTimer.repeaticTimer(interval: .seconds(1)) { _ in
            
            ANTimer.debounce(interval: .from(seconds: 1.5), identifier: "not pass") { [weak expectation] in
                //even testDebounce success. the internal timer won't stop.
                //it will cause another test method fail
                //I think XCTest framework should not call fail if XCFail is not in other test method
                if (expectation != nil) {
                    XCTFail("should not pass")
                }
            }
            
            ANTimer.debounce(interval: .from(seconds: 0.5), identifier:  "pass") {
                count = count + 1
                if count == 4 {
                    expectation.fulfill()
                }
            }
        }
        timer.start()
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testThrottle() {
        
        let expectation = self.expectation(description: "test throttle")
        
        var count = 0
        var temp = 0
        let timer = ANTimer.repeaticTimer(interval: .from(seconds: 0.1)) { _ in
            ANTimer.throttle(interval: .from(seconds: 1), identifier: "throttle", handler: {
                count = count + 1
                if count > 3 {
                    XCTFail("should not pass")
                }
                print(count)
            })
            temp = temp + 1
            print("temp: \(temp)")
            if temp == 30 {
                expectation.fulfill()
            }
        }
        timer.start()
        self.waitForExpectations(timeout: 3.2, handler: nil)
    }
    
    func testRescheduleRepeating() {
        
        let expectation = self.expectation(description: "rescheduleRepeating")
        
        var count = 0
        let timer = ANTimer.repeaticTimer(interval: .seconds(1)) { timer in
            count = count + 1
            print(Date())
            if count == 3 {
                timer.reschedule(repeating: .seconds(2))
            }
            if count == 4 {
                expectation.fulfill()
            }
        }
        timer.start()
        self.waitForExpectations(timeout: 6.1, handler: nil)
    }
    
    func testRescheduleHandler() {
        
        let expectation = self.expectation(description: "RescheduleHandler")
        
        let timer = ANTimer(interval: .seconds(2)) { _ in
            print("should not pass")
        }
        timer.reschedule { _ in
            expectation.fulfill()
        }
        timer.start()
        self.waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testCountDownTimer() {
        
        let expectation = self.expectation(description: "test count down timer")
        
        let label = UILabel()
        
        let timer = ANCountDownTimer(interval: .from(seconds: 0.1), times: 10) { _, leftTimes in
            label.text = "\(leftTimes)"
            print(label.text!)
            if label.text == "0" {
                expectation.fulfill()
            }
        }
        timer.start()
        
        self.waitForExpectations(timeout: 1.01, handler: nil)
    }
}
