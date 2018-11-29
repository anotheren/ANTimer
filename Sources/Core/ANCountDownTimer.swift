//
//  ANCountDownTimer.swift
//  ANTimer
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
    
    public func reset() {
        timer.suspend()
        leftTimes = originalTimes
    }
}
