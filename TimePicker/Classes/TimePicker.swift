//
//  TimePicker.swift
//  TimePicker
//
//  Created by Oleh Stasula on 16/02/2017.
//  Copyright © 2017 Oleh Stasula. All rights reserved.
//

import UIKit

@objc(OSTimePicker)
open class TimePicker: UIView {
    
    /// Currently selected time interval
    public var time: TimeInterval {
        return calculator.time
    }
 
    /// Configuration of the time picker instance
    public var config = TimePickerConfig() {
        didSet {
            calculator.config = config.time
            
            updateColors()
            updateFonts()
            updateTime()
        }
    }
    
    /// Enables haptic feedback if set to `true`. Default is `true`.
    public var isHapticFeedbackEnabled: Bool = true
    
    fileprivate let hourLabel = UILabel()
    fileprivate let timeLabel = UILabel()
    fileprivate let colonLabel = UILabel()
    fileprivate let periodLabel = UILabel()
    
    fileprivate lazy var calculator: TimeCalculator = {
        let calculator = TimeCalculator(config: self.config.time)
        
        calculator.didUpdateTime = {
            [unowned self]
            timeInterval in
            
            self.updateTime()
            self.feedback()
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
    fileprivate lazy var feedbackGenerator = UISelectionFeedbackGenerator()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
}

extension TimePicker {
    
    /// Reset selected time interval to initial
    open func reset() {
        calculator.reset()
    }
    
}

extension TimePicker {

    fileprivate func initialize() {
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
    }
    
    fileprivate func updateColors() {
        hourLabel.textColor = config.text.color
        timeLabel.textColor = config.text.color
        colonLabel.textColor = config.text.color
        periodLabel.textColor = config.text.color
    }
    
    fileprivate func updateFonts() {
        hourLabel.font = config.text.font
        timeLabel.font = config.text.font
        colonLabel.font = config.text.font
        periodLabel.font = config.text.font
    }
    
    fileprivate func updateTime() {
        let tf = calculator.time.timeFormat(type: config.time.format)
        
        hourLabel.text = tf.hour
        timeLabel.text = tf.minute
        periodLabel.text = tf.period
    }
    
}

extension TimePicker {
    
    fileprivate func feedback() {
        guard self.isHapticFeedbackEnabled else {
            return
        }
        feedbackGenerator.selectionChanged()
        feedbackGenerator.prepare()
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
                NSLayoutConstraint.alignHorizontally(view: periodLabel, leadingBy: timeLabel, distance: 8) +
                NSLayoutConstraint.verticallyCentered(view: periodLabel, in: self)
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
