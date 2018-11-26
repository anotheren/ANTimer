//
//  ANCountDownTimer.swift
//  ANTimer
//
//  Created by 刘栋 on 2018/7/30.
//  Copyright © 2018年 anotheren.com. All rights reserved.
//

import Dispatch

public typealias ANCountDownTimerHandler = (ANCountDownTimer, Int) -> Void

public class ANCountDownTimer {
    
    private let timer: ANTimer
    private var leftTimes: Int
    private let originalTimes: Int
    private let handler: ANCountDownTimerHandler
    
    public init(interval: DispatchTimeInterval,
                times: Int,
                queue: DispatchQueue = .main,
                handler: @escaping ANCountDownTimerHandler) {
        self.leftTimes = times
        self.originalTimes = times
        self.handler = handler
        self.timer = ANTimer.repeaticTimer(interval: interval, queue: queue, handler: { _ in })
        self.timer.reschedule { [weak self] _ in
            guard let strongSelf = self else { return }
            if strongSelf.leftTimes > 0 {
                strongSelf.leftTimes = strongSelf.leftTimes - 1
                strongSelf.handler(strongSelf, strongSelf.leftTimes)
            } else {
                strongSelf.timer.suspend()
            }
        }
    }
    
    public func start() {
        timer.start()
    }
    
    public func suspend() {
        timer.suspend()
    }
    
    public func reCountDown() {
        leftTimes = originalTimes
    }
}
