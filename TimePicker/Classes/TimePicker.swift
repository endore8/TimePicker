//
//  TimePicker.swift
//  TimePicker
//
//  Created by Oleh Stasula on 16/02/2017.
//  Copyright © 2017 Oleh Stasula. All rights reserved.
//

import UIKit

@IBDesignable
@objc(OSTimePicker)
open class TimePicker: UIView {
    
    public var time: TimeInterval {
        return calculator.time
    }
 
    public var config = TimePickerConfig() {
        didSet {
            calculator.config = config.time
            
            updateColors()
            updateFonts()
            updateTime()
            updateTexts()
        }
    }
    
    fileprivate let hourLabel = UILabel()
    fileprivate let timeLabel = UILabel()
    fileprivate let colonLabel = UILabel()
    fileprivate let periodLabel = UILabel()
    fileprivate let resetLabel = UILabel()
    
    fileprivate lazy var calculator: TimeCalculator = {
        let calculator = TimeCalculator(config: self.config.time)
        
        calculator.didUpdateTime = {
            [unowned self]
            timeInterval in
        
            self.updateTime()
        }
        
        return calculator
    }()
    fileprivate lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        UIPanGestureRecognizer(target: self, action: .handlePanGesture)
    }()
    fileprivate lazy var pressGestureRecognizer: UILongPressGestureRecognizer = {
        UILongPressGestureRecognizer(target: self, action: .handlePressGesture)
    }()
    fileprivate lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        UITapGestureRecognizer(target: self, action: .handleTapGesture)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    private func initialize() {
        addSubviews()
        prepareState()
        setupGestures()
    }
    
}

extension TimePicker {
    
    @objc fileprivate func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard point(inside: gesture.location(in: self), with: nil) else { return }
        
        let translation = gesture.translation(in: gesture.view).y
        let velocity    = gesture.velocity(in: gesture.view).y
        
        guard velocity != 0 else { return }
        
        calculator.update(percentageChange: translation / bounds.height, velocity: velocity)
    }
    
    @objc fileprivate func handlePressGesture(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            calculator.beginUpdates()
            gesture.hasUpperLocationType(in: self) ? calculator.increment() : calculator.decrement()
            
        case .changed:
            ()
            
        default:
            calculator.stopUpdates()
        }
    }
    
    @objc fileprivate func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        gesture.hasUpperLocationType(in: self) ? calculator.increment() : calculator.decrement()
    }
    
}

extension TimePicker {
    
    fileprivate func prepareState() {
        colonLabel.text = ":"
        
        updateColors()
        updateFonts()
        updateTime()
        updateTexts()
    }
    
    fileprivate func updateColors() {
        hourLabel.textColor = config.text.color
        timeLabel.textColor = config.text.color
        colonLabel.textColor = config.text.color
        periodLabel.textColor = config.text.color
        resetLabel.textColor = config.reset?.color
    }
    
    fileprivate func updateFonts() {
        hourLabel.font = config.text.font
        timeLabel.font = config.text.font
        colonLabel.font = config.text.font
        periodLabel.font = config.text.font
        resetLabel.font = config.reset?.font
    }
    
    fileprivate func updateTexts() {
        resetLabel.text = config.reset?.label
    }
    
    fileprivate func updateTime() {
        let tf = calculator.time.timeFormat(type: config.time.format)
        
        hourLabel.text = tf.hour
        timeLabel.text = tf.minute
        periodLabel.text = tf.period
        resetLabel.alpha = calculator.time == config.time.initial ? 0 : 1
    }
    
}

extension TimePicker {
    
    fileprivate func addSubviews() {
        addSubview(
            colonLabel,
            constraints: (
                NSLayoutConstraint.horizontallyCentered(view: colonLabel, in: self) +
                NSLayoutConstraint.verticallyCentered(view: colonLabel, in: self)
            )
        )
        addSubview(
            hourLabel,
            constraints: (
                NSLayoutConstraint.alignHorizontally(view: hourLabel, trailingTo: colonLabel) +
                NSLayoutConstraint.verticallyCentered(view: hourLabel, in: self)
            )
        )
        addSubview(
            timeLabel,
            constraints: (
                NSLayoutConstraint.alignHorizontally(view: timeLabel, leadingBy: colonLabel) +
                NSLayoutConstraint.verticallyCentered(view: timeLabel, in: self)
            )
        )
        addSubview(
            periodLabel,
            constraints: (
                NSLayoutConstraint.alignHorizontally(view: periodLabel, leadingBy: timeLabel) +
                NSLayoutConstraint.verticallyCentered(view: periodLabel, in: self)
            )
        )
        addSubview(
            resetLabel,
            constraints: (
                NSLayoutConstraint.horizontallyCentered(view: resetLabel, in: self) +
                NSLayoutConstraint.alignVertically(view: resetLabel, below: colonLabel, distance: 40)
            )
        )
    }
    
    private func addSubview(_ view: UIView, constraints: [NSLayoutConstraint]) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        addConstraints(constraints)
    }
    
}

extension TimePicker {
    
    fileprivate func setupGestures() {
        addGestureRecognizer(panGestureRecognizer)
        addGestureRecognizer(pressGestureRecognizer)
        addGestureRecognizer(tapGestureRecognizer)
    }
    
}

extension Selector {
    
    fileprivate static let handlePanGesture = #selector(TimePicker.handlePanGesture(_:))
    fileprivate static let handlePressGesture = #selector(TimePicker.handlePressGesture(_:))
    fileprivate static let handleTapGesture = #selector(TimePicker.handleTapGesture(_:))
    
}
