//
//  Ex+DispatchTimeInterval.swift
//  ANTimer
//
//  Created by 刘栋 on 2018/11/26.
//  Copyright © 2018 anotheren.com. All rights reserved.
//

import Dispatch

public extension DispatchTimeInterval {
    
    public static func from(seconds: Double) -> DispatchTimeInterval {
        return .milliseconds(Int(seconds * 1000))
    }
}
