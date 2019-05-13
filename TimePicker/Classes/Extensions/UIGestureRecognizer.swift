//
//  UIGestureRecognizer.swift
//  TimePicker
//
//  Created by Oleh Stasula on 15/05/2017.
//  Copyright © 2017 Oleh Stasula. All rights reserved.
//

import Foundation

extension UIGestureRecognizer {
    
    enum LocationType {
        case upper, lower
    }
    
    func tp_locationType(in view: UIView) -> LocationType {
        return self.location(in: view).y < view.bounds.height / 2 ? .upper : .lower
    }
    
    func tp_hasUpperLocationType(in view: UIView) -> Bool {
        return self.tp_locationType(in: view) == .upper
    }
    
}
