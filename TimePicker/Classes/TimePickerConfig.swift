//
//  TimePickerConfig.swift
//  TimePicker
//
//  Created by Oleh Stasula on 30/05/2017.
//  Copyright © 2017 Oleh Stasula. All rights reserved.
//

import Foundation

public struct TimePickerConfig {
    public struct Text { // Configurations for hh:mm labels
        public let color: UIColor
        public let font: UIFont
        
        public static let text = Text(color: .black, font: .systemFont(ofSize: 28, weight: UIFontWeightSemibold))
    }
    public struct Time { // Time calculator configs
        public static let timeRange = TimeInterval(0)...(24 * 60 * 60)
        public static let timeStepRange = TimeInterval(1)...30
        public static let initialTime = TimeInterval(8) * 60 * 60
        
        public enum Format {
            case auto, international, period
        }
        
        public let initial: TimeInterval
        public let step: TimeInterval
        public let format: Format
        
        public init(initial: TimeInterval = Time.initialTime, step: TimeInterval = Time.timeStepRange.lowerBound, format: Format = .auto) {
            self.initial = max(Time.timeRange.lowerBound, min(initial, Time.timeRange.upperBound))
            self.step = max(Time.timeStepRange.lowerBound, min(step, Time.timeStepRange.upperBound))
            self.format = format
        }
        
        public static let time = Time(initial: Time.initialTime, step: Time.timeStepRange.lowerBound, format: .auto)
    }
    
    public let text: Text
    public let time: Time
    
    public init(text: Text = .text, time: Time = .time) {
        self.text = text
        self.time = time
    }
}
