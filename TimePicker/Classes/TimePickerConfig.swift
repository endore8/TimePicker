//
//  TimePickerConfig.swift
//  TimePicker
//
//  Created by Oleh Stasula on 30/05/2017.
//  Copyright © 2017 Oleh Stasula. All rights reserved.
//

import Foundation

struct TimePickerConfig {
    struct Reset {
        let color: UIColor
        let font: UIFont
        let label: String
        
        static let reset = Reset(color: .gray, font: .systemFont(ofSize: 15), label: "Shake to reset")
    }
    struct Text {
        let color: UIColor
        let font: UIFont
        
        static let text = Text(color: .black, font: .systemFont(ofSize: 28, weight: UIFontWeightSemibold))
    }
    struct Time {
        static let timeRange = TimeInterval(0)...(24 * 60 * 60)
        static let timeStepRange = TimeInterval(1)...30
        static let initialTime = TimeInterval(8) * 60 * 60
        
        enum Format {
            case auto, international, period
        }
        
        let initial: TimeInterval
        let step: TimeInterval
        let format: Format
        
        init(initial: TimeInterval = Time.initialTime, step: TimeInterval = Time.timeStepRange.lowerBound, format: Format = .auto) {
            self.initial = max(Time.timeRange.lowerBound, min(initial, Time.timeRange.upperBound))
            self.step = max(Time.timeStepRange.lowerBound, min(step, Time.timeStepRange.upperBound))
            self.format = format
        }
        
        static let time = Time(initial: Time.initialTime, step: Time.timeStepRange.lowerBound, format: .auto)
    }
    
    let reset: Reset? = .reset
    let text: Text = .text
    let time: Time = .time
}
