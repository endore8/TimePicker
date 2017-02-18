//
//  TimeCalculator.swift
//  TimePicker
//
//  Created by Oleg Stasula on 17/02/2017.
//  Copyright © 2017 Oleh Stasula. All rights reserved.
//

import Foundation

fileprivate let TimeRange = TimeInterval(0)...(24 * 60 * 60)
fileprivate let TimeStepRange = TimeInterval(1)...30
fileprivate let InitialTime = TimeInterval(8) * 60 * 60

final class TimeCalculator {
    
    var didUpdateTime: ((TimeInterval) -> ())?
    
    fileprivate(set) var time: TimeInterval = InitialTime {
        didSet { didUpdateTime?(time) }
    }
    
    private var initialTimeValue = InitialTime
    var initialTime: TimeInterval {
        get {
            return initialTimeValue
        }
        set {
            let updateTime = time == initialTimeValue
            
            initialTimeValue = max(TimeRange.lowerBound, min(newValue, TimeRange.upperBound))
            
            if updateTime {
                time = initialTimeValue
            }
        }
    }
    
    private var minTimeChangeStepValue = TimeStepRange.lowerBound
    var minTimeChangeStep: TimeInterval {
        get {
            return minTimeChangeStepValue
        }
        set {
            minTimeChangeStepValue = max(TimeStepRange.lowerBound, min(newValue, TimeStepRange.upperBound))
        }
    }
    
    fileprivate var timer: Timer?
    
}

extension TimeCalculator {
    
    func increment() {
        time += minTimeChangeStep * 60
    }
    
    func decrement() {
        time -= minTimeChangeStep * 60
    }
    
}

extension TimeCalculator {
    
    func beginGradualIncrementation() {
    }
    
    func beginGradualDecrementation() {
    }
    
    func stopGradualUpdates() {
    }
    
}
