//
//  TimeInterval.swift
//  TimePicker
//
//  Created by Oleg Stasula on 18/02/2017.
//  Copyright © 2017 Oleh Stasula. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    typealias TimeFormat = (hour: String, minute: String, period: String?)
    
    private var includePeriod: Bool {
        return DateFormatter
            .dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!
            .contains("a")
    }
    
    func timeFormat(_ round: UInt = 0) -> TimeFormat {
        let value = Int(self)
        let period = includePeriod
        let hour = (value / (60 * 60)) % 24
        let minute = value / 60 % 60
        
        return (
            String(format: "%0.2d", period ? (hour % 12 == 0 ? 12 : hour % 12) : hour),
            String(format: "%0.2d", minute - (round != 0 ? (minute % Int(round)) : 0)),
            (period ? (hour < 12 ? "AM" : "PM") : nil)
        )
    }
    
    func formatToString() -> String {
        let format = timeFormat()
        
        return "\(format.hour):\(format.minute)" + (format.period != nil ? " \(format.period!)" : "")
    }
    
}
