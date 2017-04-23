//
//  TimePickerScrollView.swift
//  TimePicker
//
//  Created by Oleh Stasula on 16/02/2017.
//  Copyright © 2017 Oleh Stasula. All rights reserved.
//

import UIKit

fileprivate let ContentSize = CGSize(width: 0, height: 1_000)
fileprivate let ContentOffset = CGPoint(x: 0, y: ContentSize.height / 2)
fileprivate let ContentOffsetThresholdDivider = CGFloat(5)
fileprivate let ContentOffsetLowThreshold = ContentSize.height / ContentOffsetThresholdDivider
fileprivate let ContentOffsetHighThreshold = ContentSize.height / ContentOffsetThresholdDivider * (ContentOffsetThresholdDivider - 1)
fileprivate let ContentScrollableRange = ContentOffsetLowThreshold...ContentOffsetHighThreshold

final class TimePickerScrollView: UIScrollView {
    
    var didChangeOffsetCallback: ((_ delta: CGFloat) -> ())?
    
    fileprivate var prevContentOffset: CGPoint = .zero
    
    convenience init() {
        self.init(frame: .zero)
        
        self.contentOffset = ContentOffset
        self.contentSize = ContentSize
        self.delegate = self
        self.prevContentOffset = self.contentOffset
    }
    
}

extension TimePickerScrollView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard prevContentOffset != scrollView.contentOffset else { return }
        
        didChangeOffsetCallback?(scrollView.contentOffset.y - prevContentOffset.y)
        
        if !ContentScrollableRange.contains(scrollView.contentOffset.y) {
            prevContentOffset = ContentOffset
            scrollView.contentOffset = prevContentOffset
        }
        else {
            prevContentOffset = scrollView.contentOffset
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        prevContentOffset = scrollView.contentOffset
    }
    
}
