//
//  TimeCalculator.swift
//  TimePicker
//
//  Created by Oleh Stasula on 17/02/2017.
//  Copyright © 2017 Oleh Stasula. All rights reserved.
//

import Foundation

final class TimeCalculator {
    
    var didUpdateTime: ((TimeInterval) -> ())?
    
    var config: TimePickerConfig.Time {
        didSet {
            if time == oldValue.initial {
                time = config.initial
            }
            
            if step == oldValue.step {
                step = config.step
            }
            else if step == -oldValue.step {
                step = -config.step
            }
        }
    }
    
    fileprivate(set) var time: TimeInterval {
        didSet {
            guard oldValue.timeFormat() != time.timeFormat() else { return }
            
            didUpdateTime?(time)
        }
    }
    
    fileprivate var step: TimeInterval?
    fileprivate var timer: Timer?
    
    init(config: TimePickerConfig.Time) {
        self.config = config
        self.time = config.initial
    }
    
}

extension TimeCalculator {
    
    func increment() {
        time += config.step.minutes
        
        if timer != nil {
            step = config.step
        }
    }
    
    func decrement() {
        time -= config.step.minutes
        
        if timer != nil {
            step = -config.step
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
        var multiplier: CGFloat = 0
        
        switch abs(velocity) {
        case 0..<50:
            multiplier = 0.2
        case 51..<200:
            multiplier = 0.5
        case 201..<1000:
            multiplier = 0.75
        default:
            multiplier = 1
        }
        
        var t = time + TimeInterval(change * 100 * multiplier).minutes
        t.normalize(min: TimePickerConfig.Time.timeRange.lowerBound, max: TimePickerConfig.Time.timeRange.upperBound)
        time = t
    }
    
}
