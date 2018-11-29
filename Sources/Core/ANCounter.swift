//
//  ANCounter.swift
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

public typealias ANCounterHandler = (Int) -> Void

public class ANCounter {
    
    private let timer: ANTimer
    private var count: Int = 0
    private var handler: ANCounterHandler
    
    public init(interval: DispatchTimeInterval = .seconds(1),
                queue: DispatchQueue = .main,
                handler: @escaping ANCounterHandler) {
        self.timer = ANTimer.repeaticTimer(interval: interval, queue: queue, handler: { _ in })
        self.handler = handler
        self.timer.reschedule { [weak self] _ in
            guard let strongSelf = self else { return }
            let count = strongSelf.count
            strongSelf.handler(count)
            strongSelf.count = 0
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
        count = 0
    }
    
    public func add() {
        count += 1
    }
}
