//
//  ScrollTouchViewController.swift
//  ScrollViewPlay
//
//  Created by Teodor Patras on 05/07/15.
//  Copyright (c) 2015 Teodor Patras. All rights reserved.
//

import UIKit

class ScrollTouchViewController: UIViewController, UIGestureRecognizerDelegate {

    var dotViewsPlaced = false
    var canvasView : UIView!
    var scrollView : OverlayScrollView!
    var drawerView : UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        canvasView = UIView()
        scrollView = OverlayScrollView()
        drawerView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        
        scrollView.addSubview(drawerView)
        self.view.addSubview(canvasView)
        self.view.addSubview(scrollView)
        
        self.scrollView.showsVerticalScrollIndicator = false
        
        self.view.addGestureRecognizer(scrollView.panGestureRecognizer)
        
        self.canvasView.addGestureRecognizer(TouchDelayRecognizer(target: self, action: ""))
        
        self.navigationItem.title = "Touch events handling"
        
    }
    
    override func viewDidLayoutSubviews() {
        
        canvasView.frame = self.view.bounds
        scrollView.frame = self.view.bounds
        
        if !dotViewsPlaced {
            
            drawerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 350)
            
            
            scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height + drawerView.bounds.size.height)
            
            scrollView.contentOffset = CGPointMake(0, drawerView.bounds.size.height)
            
            dotViewsPlaced = true
            
            DotView.placeRandomViewsWithinSuperview(self.canvasView, numberOfViews: 15, target: self, selector: "handleLongPress:")
            DotView.placeRandomViewsWithinSuperview(self.drawerView.contentView, numberOfViews: 5, target: self, selector: "handleLongPress:")
        }
    }

    func handleLongPress(gesture : UILongPressGestureRecognizer){
        let dot = gesture.view as! DotView
        
        switch gesture.state {
        case .Began :
            grabDot(dot, gestureRecognizer: gesture)
        case .Changed :
            moveDot(dot, gestureRecognizer: gesture)
        case .Cancelled, .Ended :
            dropDot(dot, gestureRecognizer: gesture)
        default :
            break
        }
    }
    
    func grabDot(dot : DotView, gestureRecognizer : UILongPressGestureRecognizer){
        
        dot.center = self.view.convertPoint(dot.center, fromView: dot.superview)
        self.view.addSubview(dot)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            dot.transform = CGAffineTransformMakeScale(1.2, 1.2)
            dot.alpha = 0.8
            self.moveDot(dot, gestureRecognizer: gestureRecognizer)
        })
        
        // get the touch away from the pan gesture
        
        self.scrollView.panGestureRecognizer.enabled = false
        self.scrollView.panGestureRecognizer.enabled = true
    }
    
    func moveDot(dot : DotView, gestureRecognizer : UILongPressGestureRecognizer){
        dot.center = gestureRecognizer.locationInView(self.view)
    }

    func dropDot(dot : DotView, gestureRecognizer : UILongPressGestureRecognizer){
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            dot.transform = CGAffineTransformIdentity
            dot.alpha = 1
        })
        
        let location = gestureRecognizer.locationInView(drawerView)
        
        if CGRectContainsPoint(drawerView.bounds, location) {
            drawerView.contentView.addSubview(dot)
        } else {
            canvasView.addSubview(dot)
        }
        
        dot.center = self.view.convertPoint(dot.center, toView: dot.superview)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer == self.scrollView.panGestureRecognizer
    }
}
