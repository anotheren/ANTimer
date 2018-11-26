//
//  ANTimer+Throttle.swift
//  ANTimer
//
//  Created by 刘栋 on 2018/7/30.
//  Copyright © 2018年 anotheren.com. All rights reserved.
//

import Dispatch

public typealias ANThrottleTimerHandler = () -> Void

public extension ANTimer {
    
    private static var workItems = [String: DispatchWorkItem]()
    
    /// The Handler will be called after interval you specified
    /// Calling again in the interval cancels the previous call
    
    public static func debounce(interval: DispatchTimeInterval,
                                identifier: String,
                                queue: DispatchQueue = .main,
                                handler: @escaping ANThrottleTimerHandler) {
        // if already exist
        if let item = workItems[identifier] {
            item.cancel()
        }
        
        let item = DispatchWorkItem {
            handler()
            workItems.removeValue(forKey: identifier)
        }
        workItems[identifier] = item
        queue.asyncAfter(deadline: .now() + interval, execute: item)
    }
    
    /// The Handler will be called after interval you specified
    /// It is invalid to call again in the interval
    
    public static func throttle(interval: DispatchTimeInterval,
                                identifier: String,
                                queue: DispatchQueue = .main,
                                handler: @escaping ANThrottleTimerHandler) {
        // if already exist
        if workItems[identifier] != nil {
            return
        }
        
        let item = DispatchWorkItem {
            handler()
            workItems.removeValue(forKey: identifier)
        }
        workItems[identifier] = item
        queue.asyncAfter(deadline: .now() + interval, execute: item)
    }
    
    public static func cancel(throttlingTimer identifier: String) {
        if let item = workItems[identifier] {
            item.cancel()
            workItems.removeValue(forKey: identifier)
        }
    }
}
