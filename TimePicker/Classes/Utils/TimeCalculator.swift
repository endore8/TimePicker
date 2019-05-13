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
            if self.time == oldValue.initial {
                self.time = self.config.initial
            }
            
            if self.step == oldValue.step {
                self.step = self.config.step
            }
            else if self.step == -oldValue.step {
                self.step = -self.config.step
            }
        }
    }
    
    fileprivate(set) var time: TimeInterval {
        didSet {
            guard oldValue.timeFormat() != self.time.timeFormat() else { return }
            
            self.didUpdateTime?(self.time)
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
        self.updateTime(newTime: self.time + self.config.step.minutes)
        
        if self.timer != nil {
            self.step = self.config.step
        }
    }
    
    func decrement() {
        self.updateTime(newTime: self.time - self.config.step.minutes)
        
        if self.timer != nil {
            self.step = -self.config.step
        }
    }
    
}

extension TimeCalculator {
    
    func beginUpdates() {
        guard self.timer == nil else { return }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true, block: {
            [weak self]
            (_) in
            
            guard let sself = self, let step = sself.step else { return }
            
            sself.updateTime(newTime: sself.time + step.minutes)
        })
        self.timer?.fire()
    }
    
    func stopUpdates() {
        self.step = nil
        self.timer?.invalidate()
        self.timer = nil
    }
    
}

extension TimeCalculator {
    
    func update(percentageChange change: CGFloat, velocity: CGFloat) {
        var multiplier: CGFloat = 0
        
        switch abs(velocity) {
        case 0..<150:
            multiplier = 1
        case 151..<400:
            multiplier = 2
        case 401..<1000:
            multiplier = 4
        default:
            multiplier = 8
        }
        
        let step = TimeInterval(change * multiplier)
        let normalizedAbsStep = max(abs(step), self.config.step)
        let signedStep = change < 0 ? -normalizedAbsStep : normalizedAbsStep;
        self.updateTime(newTime: self.time + signedStep.minutes)
    }
    
}

extension TimeCalculator {
    
    func reset() {
        self.updateTime(newTime: self.config.initial)
    }
    
}

extension TimeCalculator {
    
    fileprivate func updateTime(newTime time: TimeInterval) {
        var tmp = TimeInterval(Int(time / self.config.step.minutes)) * self.config.step.minutes
        tmp.normalize(min: TimePickerConfig.Time.timeRange.lowerBound, max: TimePickerConfig.Time.timeRange.upperBound)
        self.time = tmp
    }
    
}
