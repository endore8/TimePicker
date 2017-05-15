//
//  TimeFormat.swift
//  TimePicker
//
//  Created by Oleh Stasula on 20/02/2017.
//  Copyright © 2017 Oleh Stasula. All rights reserved.
//

import Foundation

typealias TimeFormat = (hour: String, minute: String, period: String?)

func !=(t1: TimeFormat, t2: TimeFormat) -> Bool {
    return !(
        t1.hour == t2.hour &&
        t1.minute == t2.minute &&
        t1.period == t2.period
    )
}
