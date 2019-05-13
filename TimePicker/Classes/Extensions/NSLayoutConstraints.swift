//
//  NSLayoutConstraints.swift
//  TimePicker
//
//  Created by Oleh Stasula on 17/02/2017.
//  Copyright © 2017 Oleh Stasula. All rights reserved.
//

import Foundation

extension NSLayoutConstraint {
    
    static func tp_horizontallyCentered(view: UIView, in superview: UIView) -> [NSLayoutConstraint] {
        return self.constraints(
            withVisualFormat: "V:[superview]-(<=1)-[view]",
            options: .alignAllCenterX,
            metrics: nil,
            views: ["superview": superview, "view": view]
        )
    }
    
    static func tp_verticallyCentered(view: UIView, in superview: UIView) -> [NSLayoutConstraint] {
        return self.constraints(
            withVisualFormat: "H:[superview]-(<=1)-[view]",
            options: .alignAllCenterY,
            metrics: nil,
            views: ["superview": superview, "view": view]
        )
    }
    
    static func tp_alignHorizontally(view: UIView, trailingTo trailingView: UIView, distance: CGFloat = 0) -> [NSLayoutConstraint] {
        return self.constraints(
            withVisualFormat: "H:[view]-distance-[trailingView]",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: ["distance": distance],
            views: ["view": view, "trailingView": trailingView]
        )
    }
    
    static func tp_alignHorizontally(view: UIView, leadingBy leadingView: UIView, distance: CGFloat = 0) -> [NSLayoutConstraint] {
        return self.constraints(
            withVisualFormat: "H:[leadingView]-distance-[view]",
            options: NSLayoutConstraint.FormatOptions(),
            metrics: ["distance": distance],
            views: ["view": view, "leadingView": leadingView]
        )
    }
    
}
