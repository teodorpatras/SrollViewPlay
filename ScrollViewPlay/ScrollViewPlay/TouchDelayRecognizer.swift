//
//  TouchDelayRecognizer.swift
//  ScrollViewPlay
//
//  Created by Teodor Patras on 05/07/15.
//  Copyright (c) 2015 Teodor Patras. All rights reserved.
//

import UIKit

class TouchDelayRecognizer: UIGestureRecognizer {
   
    var timer : NSTimer?
    
    override init(target: AnyObject, action: Selector) {
        super.init(target: target, action: action)
         self.delaysTouchesBegan = true
    }
    
    func fail () {
        self.state = .Failed
    }
    
    override func reset () {
        timer?.invalidate()
        timer = nil
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        timer = NSTimer.scheduledTimerWithTimeInterval(0.15, target: self, selector: "fail", userInfo: nil, repeats: false)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.fail()
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        self.fail()
    }
}
