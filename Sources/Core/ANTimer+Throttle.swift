//
//  ANTimer+Throttle.swift
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

public typealias ANThrottleTimerHandler = () -> Void

extension ANTimer {
    
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
