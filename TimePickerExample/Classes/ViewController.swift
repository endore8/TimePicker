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
        
        updateViews()
    }
    
}

extension ViewController {
    
    @IBAction fileprivate func controlEvent(_ sender: Any) {
        updateConfig()
        updateViews()
    }
    
}

extension ViewController {
    
    fileprivate func updateConfig() {
        timePicker.config = TimePickerConfig(
            text: TimePickerConfig.Text.text,
            time: TimePickerConfig.Time(
                initial: TimeInterval(Int(hourSlider.value) * 60 * 60),
                step: TimeInterval(Int(stepSlider.value)),
                format: formatSegment.format
            )
        )
    }
    
    fileprivate func updateViews() {
        stepLabel.text = "Step \(Int(stepSlider.value)) min"
        hourLabel.text = "Initial hour \(Int(hourSlider.value))"
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
