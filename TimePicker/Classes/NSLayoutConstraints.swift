//
//  NSLayoutConstraints.swift
//  TimePicker
//
//  Created by Oleg Stasula on 17/02/2017.
//  Copyright © 2017 Oleh Stasula. All rights reserved.
//

import Foundation

extension NSLayoutConstraint {
    
    static func horizontallyCentered(view: UIView, in superview: UIView) -> [NSLayoutConstraint] {
        return constraints(
            withVisualFormat: "V:[superview]-(<=1)-[view]",
            options: .alignAllCenterX,
            metrics: nil,
            views: ["superview": superview, "view": view]
        )
    }
    
    static func verticallyCentered(view: UIView, in superview: UIView) -> [NSLayoutConstraint] {
        return constraints(
            withVisualFormat: "H:[superview]-(<=1)-[view]",
            options: .alignAllCenterY,
            metrics: nil,
            views: ["superview": superview, "view": view]
        )
    }
    
    static func alignHorizontally(view: UIView, trailingTo trailingView: UIView, distance: CGFloat = 0) -> [NSLayoutConstraint] {
        return constraints(
            withVisualFormat: "H:[view]-distance-[trailingView]",
            options: NSLayoutFormatOptions(),
            metrics: ["distance": distance],
            views: ["view": view, "trailingView": trailingView]
        )
    }
    
    static func alignHorizontally(view: UIView, leadingBy leadingView: UIView, distance: CGFloat = 0) -> [NSLayoutConstraint] {
        return constraints(
            withVisualFormat: "H:[leadingView]-distance-[view]",
            options: NSLayoutFormatOptions(),
            metrics: ["distance": distance],
            views: ["view": view, "leadingView": leadingView]
        )
    }
    
}
