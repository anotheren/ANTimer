//
//  ANTimer.swift
//  ANTimer
//
//  Created by 刘栋 on 2018/7/30.
//  Copyright © 2018年 anotheren.com. All rights reserved.
//

import Dispatch

public typealias SPTimerHandler = (ANTimer) -> Void

public class ANTimer {
    
    private let timer: DispatchSourceTimer
    private var isRunning = false
    public let repeats: Bool
    private var handler: SPTimerHandler
    
    public init(interval: DispatchTimeInterval,
                repeats: Bool = false,
                leeway: DispatchTimeInterval = .seconds(0),
                queue: DispatchQueue = .main,
                handler: @escaping SPTimerHandler) {
        self.handler = handler
        self.repeats = repeats
        self.timer = DispatchSource.makeTimerSource(queue: queue)
        self.timer.setEventHandler { [weak self] in
            guard let strongSelf = self else { return }
            handler(strongSelf)
        }
        
        if repeats {
            self.timer.schedule(deadline: .now() + interval, repeating: interval, leeway: leeway)
        } else {
            self.timer.schedule(deadline: .now() + interval, leeway: leeway)
        }
    }
    
    deinit {
        if !self.isRunning {
            timer.resume()
        }
    }
    
    public static func repeaticTimer(interval: DispatchTimeInterval,
                                     leeway: DispatchTimeInterval = .seconds(0),
                                     queue: DispatchQueue = .main,
                                     handler: @escaping SPTimerHandler) -> ANTimer {
        return ANTimer(interval: interval, repeats: true, leeway: leeway, queue: queue, handler: handler)
    }
    
    // You can use this method to fire a repeating timer without interrupting its regular firing schedule. If the timer is non-repeating, it is automatically invalidated after firing, even if its scheduled fire date has not arrived.
    
    public func fire() {
        if repeats {
            handler(self)
        } else {
            handler(self)
            timer.cancel()
        }
    }
    
    public func start() {
        if !isRunning {
            timer.resume()
            isRunning = true
        }
    }
    
    public func suspend() {
        if isRunning {
            timer.suspend()
            isRunning = false
        }
    }
    
    public func reschedule(repeating interval: DispatchTimeInterval) {
        if repeats {
            timer.schedule(deadline: .now() + interval, repeating: interval)
        }
    }
    
    public func reschedule(handler: @escaping SPTimerHandler) {
        self.handler = handler
        timer.setEventHandler { [weak self] in
            guard let strongSelf = self else { return }
            handler(strongSelf)
        }
    }
}
