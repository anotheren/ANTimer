//
//  Ex+DispatchTimeInterval.swift
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
//  Created by 刘栋 on 2018/11/26.
//  Copyright © 2018 anotheren.com. All rights reserved.
//

import Dispatch

extension DispatchTimeInterval: ANTimerCompatible { }

extension ANTimerBase where TimerObject == DispatchTimeInterval {
    
    public static func from(seconds: Double) -> DispatchTimeInterval {
        return .milliseconds(Int(seconds * 1000))
    }
}
