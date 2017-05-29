//
//  TimeCalculator.swift
//  TimePicker
//
//  Created by Oleh Stasula on 17/02/2017.
//  Copyright © 2017 Oleh Stasula. All rights reserved.
//

import Foundation

fileprivate let TimeRange = TimeInterval(0)...(24 * 60 * 60)
fileprivate let TimeStepRange = TimeInterval(1)...30
fileprivate let InitialTime = TimeInterval(8) * 60 * 60

final class TimeCalculator {
    
    var didUpdateTime: ((TimeInterval) -> ())?
    
    fileprivate(set) var time: TimeInterval = InitialTime {
        didSet {
            guard oldValue.timeFormat() != time.timeFormat() else { return }
            
            didUpdateTime?(time)
        }
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
    fileprivate var step: TimeInterval?
    
}

extension TimeCalculator {
    
    func increment() {
        time += minTimeChangeStep.minutes
        
        if timer != nil {
            step = minTimeChangeStep
        }
    }
    
    func decrement() {
        time -= minTimeChangeStep.minutes
        
        if timer != nil {
            step = -minTimeChangeStep
        }
    }
    
}

extension TimeCalculator {
    
    func beginUpdates() {
        guard timer == nil else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true, block: {
            [weak self]
            (_) in
            
            guard let sself = self, let step = sself.step else { return }
            
            sself.time += step.minutes
        })
        timer?.fire()
    }
    
    func stopUpdates() {
        step = nil
        timer?.invalidate()
        timer = nil
    }
    
}

extension TimeCalculator {
    
    func update(percentageChange change: CGFloat, velocity: CGFloat) {
        var t = time + TimeInterval(change * 100).minutes
        t.normalize(min: TimeRange.lowerBound, max: TimeRange.upperBound)
        time = t
    }
    
}
