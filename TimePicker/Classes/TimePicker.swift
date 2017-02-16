//
//  TimePicker.swift
//  TimePicker
//
//  Created by Oleg Stasula on 16/02/2017.
//  Copyright © 2017 Oleh Stasula. All rights reserved.
//

import UIKit

@objc(OSTimePicker)
open class TimePicker: UIView {
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func initialize() {
    }
    
}

