//
//  DotView.swift
//  ScrollViewPlay
//
//  Created by Teodor Patras on 05/07/15.
//  Copyright (c) 2015 Teodor Patras. All rights reserved.
//

import UIKit

class DotView: UIView {
    
    var color = UIColor.whiteColor()
    var highlightColor = UIColor.blackColor()
    
    class func placeRandomViewsWithinSuperview(superview : UIView, numberOfViews : Int, target : UIGestureRecognizerDelegate?, selector: Selector?)
    {
        for i in 1...numberOfViews {
            let randomDim = CGFloat(max(10, arc4random() % 100))
            let bounds = superview.bounds
            let randomYCenter = max (randomDim / 2 + 10, CGFloat(arc4random()) % (bounds.size.height - randomDim / 2))
            let randomXCenter = max (randomDim / 2  + 10, CGFloat(arc4random()) % (bounds.size.width - randomDim / 2))
            
            let view = DotView(frame: CGRectMake(0, 0, randomDim, randomDim))
            view.center = CGPointMake(randomXCenter, randomYCenter)
            superview.addSubview(view)
            
            view.backgroundColor = randomColor()
            view.color = view.backgroundColor!
            view.highlightColor = view.darkerColor()
            
            view.layer.cornerRadius = randomDim / 2
            
            if let t = target, let s = selector {
                let gesture = UILongPressGestureRecognizer(target: t, action: s)
                view.addGestureRecognizer(gesture)
                gesture.cancelsTouchesInView = false
                gesture.delegate = target
            }
        }
    }
    
    func darkerColor() -> UIColor{
        
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let darkeningFactor : CGFloat = 0.3
        
        return UIColor(red: max (r - darkeningFactor, 0.0), green: max (0.0, g - darkeningFactor), blue: max(b - darkeningFactor, 0.0), alpha: a)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.backgroundColor = self.highlightColor
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.backgroundColor = color
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        self.backgroundColor = color
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        var touchBounds = self.bounds
        if CGRectGetWidth(touchBounds) < 44 {
            let expansion = 44 - CGRectGetWidth(touchBounds)
            touchBounds = CGRectInset(touchBounds, -expansion, -expansion)
        }
        
        return CGRectContainsPoint(touchBounds, point)
    }
}
