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
    fileprivate var incrementationStep: TimeInterval?
    
}

extension TimeCalculator {
    
    func increment() {
        time += minTimeChangeStep.minutes
    }
    
    func decrement() {
        time -= minTimeChangeStep.minutes
    }
    
}

extension TimeCalculator {
    
    func beginContinuousIncrementation() {
        stopContinuousUpdates()
        
        incrementationStep = minTimeChangeStep
        
        scheduleTimer()
    }
    
    func beginContinuousDecrementation() {
        stopContinuousUpdates()
        
        incrementationStep = -minTimeChangeStep
        
        scheduleTimer()
    }
    
    func stopContinuousUpdates() {
        stopTimer()
        incrementationStep = nil
    }

    private func scheduleTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true, block: {
            [weak self]
            (_) in
            
            guard let sself = self, let step = sself.incrementationStep else { return }
            
            sself.time += step.minutes
        })
        timer?.fire()
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
}

extension TimeCalculator {
    
    func update(percentageChange change: CGFloat) {
        time += TimeInterval(change * 100).minutes
    }
    
}

extension TimeInterval {
    
    var minutes: TimeInterval {
        guard (TimeInterval(0)..<60).contains(abs(self)) else { return self }
        
        return self * 60
    }
    
}
