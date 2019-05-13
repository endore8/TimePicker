//
//  TimeInterval.swift
//  TimePicker
//
//  Created by Oleh Stasula on 18/02/2017.
//  Copyright © 2017 Oleh Stasula. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    private var shouldIncludePeriod: Bool {
        return DateFormatter
            .dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!
            .contains("a")
    }
    
    func timeFormat(_ round: UInt = 0, type: TimePickerConfig.Time.Format = .auto) -> TimeFormat {
        let value = Int(self)
        let period = (type == .auto ? self.shouldIncludePeriod : (type == .international ? false : true))
        let hour = (value / (60 * 60)) % 24
        let minute = value / 60 % 60
        
        return (
            String(format: "%0.2d", period ? (hour % 12 == 0 ? 12 : hour % 12) : hour),
            String(format: "%0.2d", minute - (round != 0 ? (minute % Int(round)) : 0)),
            (period ? (hour < 12 ? "AM" : "PM") : nil)
        )
    }
    
    func formatToString() -> String {
        let format = self.timeFormat()
        
        return "\(format.hour):\(format.minute)" + (format.period != nil ? " \(format.period!)" : "")
    }
    
    mutating func normalize(min: TimeInterval, max: TimeInterval) {
        if self > max {
            self = self.truncatingRemainder(dividingBy: max)
        }
        else if self < min {
            self = max + self
        }
    }
    
}

extension TimeInterval {
    
    var minutes: TimeInterval {
        guard (TimeInterval(0)..<60).contains(abs(self)) else { return self }
        
        return self * 60
    }
    
}
