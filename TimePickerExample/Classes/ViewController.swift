//
//  ViewController.swift
//  TimePickerExample
//
//  Created by Oleh Stasula on 16/02/2017.
//  Copyright © 2017 Oleh Stasula. All rights reserved.
//

import TimePicker
import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet fileprivate weak var timePicker: TimePicker!
    
    @IBOutlet fileprivate weak var stepLabel: UILabel!
    @IBOutlet fileprivate weak var stepSlider: UISlider!
    
    @IBOutlet fileprivate weak var hourLabel: UILabel!
    @IBOutlet fileprivate weak var hourSlider: UISlider!
    
    @IBOutlet fileprivate weak var formatSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateViews()
    }
    
}

extension ViewController {
    
    @IBAction fileprivate func controlEvent(_ sender: Any) {
        self.updateConfig()
        self.updateViews()
    }
    
    @IBAction fileprivate func reset(_ sender: Any) {
        self.timePicker.reset()
    }
    
    @IBAction fileprivate func triggerHapticFeedback(_ sender: UISwitch) {
        self.timePicker.isHapticFeedbackEnabled = sender.isOn
    }
    
}

extension ViewController {
    
    fileprivate func updateConfig() {
        self.timePicker.config = TimePickerConfig(
            text: TimePickerConfig.Text.text,
            time: TimePickerConfig.Time(
                initial: TimeInterval(Int(self.hourSlider.value) * 60 * 60),
                step: TimeInterval(Int(self.stepSlider.value)),
                format: self.formatSegment.format
            )
        )
    }
    
    fileprivate func updateViews() {
        self.stepLabel.text = "Step \(Int(self.stepSlider.value)) min"
        self.hourLabel.text = "Initial hour \(Int(self.hourSlider.value))"
    }
    
}

extension UISegmentedControl {
    
    fileprivate var format: TimePickerConfig.Time.Format {
        switch self.selectedSegmentIndex {
        case 1:
            return .international
        case 2:
            return .period
        default:
            return .auto
        }
    }
    
}
