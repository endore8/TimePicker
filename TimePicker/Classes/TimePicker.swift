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
        return self.calculator.time
    }
 
    /// Configuration of the time picker instance
    public var config = TimePickerConfig() {
        didSet {
            self.calculator.config = self.config.time
            
            self.updateColors()
            self.updateFonts()
            self.updateTime()
        }
    }
    
    /// Enables haptic feedback if set to `true`. Default is `true`.
    public var isHapticFeedbackEnabled: Bool = true
    
    private let hourLabel = UILabel()
    private let timeLabel = UILabel()
    private let colonLabel = UILabel()
    private let periodLabel = UILabel()
    
    private let calculator: TimeCalculator
    private let feedbackGenerator: UISelectionFeedbackGenerator
    
    private var lastPanTranslation: CGFloat?
    
    override init(frame: CGRect) {
        self.calculator = TimeCalculator(config: self.config.time)
        self.feedbackGenerator = UISelectionFeedbackGenerator()
        
        super.init(frame: frame)
        
        self.initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.calculator = TimeCalculator(config: self.config.time)
        self.feedbackGenerator = UISelectionFeedbackGenerator()
        
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
}

extension TimePicker {
    
    /// Reset selected time interval to initial
    open func reset() {
        self.calculator.reset()
    }
    
}

extension TimePicker {

    private func initialize() {
        self.calculator.didUpdateTime = {
            [unowned self]
            timeInterval in
            
            self.updateTime()
            self.feedback()
        }
        
        self.addSubviews()
        self.prepareState()
        self.setupGestures()
    }
    
}

extension TimePicker {
    
    @objc fileprivate func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard self.point(inside: gesture.location(in: self), with: nil) else { return }
        
        switch gesture.state {
        case .began:
            self.lastPanTranslation = gesture.translation(in: gesture.view).y
        
        case .changed:
            guard let lastTranslation = self.lastPanTranslation else { break }
            let translation = gesture.translation(in: gesture.view).y
            let change = lastTranslation - translation
            guard abs(change) >= 5 else { break }
            let velocity = gesture.velocity(in: gesture.view).y
            self.calculator.update(percentageChange: change,
                                   velocity: velocity)
            self.lastPanTranslation = translation
            
        case .ended, .cancelled, .failed:
            self.lastPanTranslation = nil
            
        default:
            break
        }
    }
    
    @objc fileprivate func handlePressGesture(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            self.calculator.beginUpdates()
            gesture.tp_hasUpperLocationType(in: self) ? self.calculator.increment() : self.calculator.decrement()
            
        case .changed:
            ()
            
        default:
            self.calculator.stopUpdates()
        }
    }
    
    @objc fileprivate func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        gesture.tp_hasUpperLocationType(in: self) ? self.calculator.increment() : self.calculator.decrement()
    }
    
}

extension TimePicker {
    
    fileprivate func prepareState() {
        self.colonLabel.text = ":"
        
        self.updateColors()
        self.updateFonts()
        self.updateTime()
    }
    
    fileprivate func updateColors() {
        self.hourLabel.textColor = self.config.text.color
        self.timeLabel.textColor = self.config.text.color
        self.colonLabel.textColor = self.config.text.color
        self.periodLabel.textColor = self.config.text.color
    }
    
    fileprivate func updateFonts() {
        self.hourLabel.font = self.config.text.font
        self.timeLabel.font = self.config.text.font
        self.colonLabel.font = self.config.text.font
        self.periodLabel.font = self.config.text.font
    }
    
    fileprivate func updateTime() {
        let tf = self.calculator.time.timeFormat(type: self.config.time.format)
        
        self.hourLabel.text = tf.hour
        self.timeLabel.text = tf.minute
        self.periodLabel.text = tf.period
    }
    
}

extension TimePicker {
    
    fileprivate func feedback() {
        guard self.isHapticFeedbackEnabled else {
            return
        }
        self.feedbackGenerator.selectionChanged()
        self.feedbackGenerator.prepare()
    }
    
}

extension TimePicker {
    
    fileprivate func addSubviews() {
        self.addSubview(
            self.colonLabel,
            constraints: (
                NSLayoutConstraint.tp_horizontallyCentered(view: self.colonLabel, in: self) +
                NSLayoutConstraint.tp_verticallyCentered(view: self.colonLabel, in: self)
            )
        )
        self.addSubview(
            self.hourLabel,
            constraints: (
                NSLayoutConstraint.tp_alignHorizontally(view: self.hourLabel, trailingTo: self.colonLabel) +
                NSLayoutConstraint.tp_verticallyCentered(view: self.hourLabel, in: self)
            )
        )
        self.addSubview(
            self.timeLabel,
            constraints: (
                NSLayoutConstraint.tp_alignHorizontally(view: self.timeLabel, leadingBy: self.colonLabel) +
                NSLayoutConstraint.tp_verticallyCentered(view: self.timeLabel, in: self)
            )
        )
        self.addSubview(
            self.periodLabel,
            constraints: (
                NSLayoutConstraint.tp_alignHorizontally(view: self.periodLabel, leadingBy: self.timeLabel, distance: 8) +
                NSLayoutConstraint.tp_verticallyCentered(view: self.periodLabel, in: self)
            )
        )
    }
    
    private func addSubview(_ view: UIView, constraints: [NSLayoutConstraint]) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        self.addConstraints(constraints)
    }
    
}

extension TimePicker {
    
    fileprivate func setupGestures() {
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: .handlePanGesture))
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: .handlePressGesture))
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: .handleTapGesture))
    }
    
}

extension Selector {
    
    fileprivate static let handlePanGesture = #selector(TimePicker.handlePanGesture(_:))
    fileprivate static let handlePressGesture = #selector(TimePicker.handlePressGesture(_:))
    fileprivate static let handleTapGesture = #selector(TimePicker.handleTapGesture(_:))
}
