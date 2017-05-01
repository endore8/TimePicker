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
 
    @IBInspectable public var textColor: UIColor = .black {
        didSet { updateColors() }
    }
    @IBInspectable public var textFont: UIFont = .systemFont(ofSize: 20) {
        didSet { updateFonts() }
    }
    @IBInspectable public var isShakeToResetEnabled: Bool = false {
        didSet {}
    }
    @IBInspectable public var shakeToResetColor: UIColor = .lightGray {
        didSet {}
    }
    @IBInspectable public var shakeToResetFont: UIFont = .systemFont(ofSize: 15) {
        didSet {}
    }
    @IBInspectable public var shakeToResetText: String = "Shake to reset" {
        didSet {}
    }
    @IBInspectable public var isHapticFeedbackEnabled: Bool = true
    
    fileprivate let hourLabel = UILabel()
    fileprivate let timeLabel = UILabel()
    fileprivate let colonLabel = UILabel()
    fileprivate let periodLabel = UILabel()
    
    fileprivate lazy var calculator: TimeCalculator = {
        let calculator = TimeCalculator()
        
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
        backgroundColor = .lightGray
        
        addSubviews()
        prepareState()
        setupGestures()
    }
    
}

extension TimePicker {
    
    @objc fileprivate func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
    }
    
    @objc fileprivate func handlePressGesture(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            gesture.hasUpperLocationType(in: self) ? calculator.beginContinuousIncrementation() : calculator.beginContinuousDecrementation()
            
        case .changed:
            ()
            
        default:
            calculator.stopContinuousUpdates()
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
    }
    
    fileprivate func updateFonts() {
    }
    
    fileprivate func updateTime() {
        let tf = calculator.time.timeFormat()
        
        hourLabel.text = tf.hour
        timeLabel.text = tf.minute
        periodLabel.text = tf.period
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


extension UIGestureRecognizer {
    
    fileprivate enum LocationType {
        case upper, lower
    }
    
    fileprivate func locationType(in view: UIView) -> LocationType {
        return location(in: view).y < view.bounds.height / 2 ? .upper : .lower
    }
    
    fileprivate func hasUpperLocationType(in view: UIView) -> Bool {
        return locationType(in: view) == .upper
    }
    
}

extension Selector {
    
    fileprivate static let handlePanGesture = #selector(TimePicker.handlePanGesture(_:))
    fileprivate static let handlePressGesture = #selector(TimePicker.handlePressGesture(_:))
    fileprivate static let handleTapGesture = #selector(TimePicker.handleTapGesture(_:))
    
}
