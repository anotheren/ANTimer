//
//  ANCounter.swift
//  ANTimer
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
    
    public func add() {
        count += 1
    }
}
