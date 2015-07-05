//
//  HeaderZoomScrollView.swift
//  ScrollViewPlay
//
//  Created by Teodor Patras on 02/07/15.
//  Copyright (c) 2015 Teodor Patras. All rights reserved.
//

import UIKit

class HeaderZoomScrollView: UIScrollView, UIScrollViewDelegate {

    
    // MARK:- Subviews -
    
    let rocketsView : UIImageView
    let starsView : UIImageView
    
    // MARK:- Constants -
    
    let topMargin : CGFloat = 0
    let rocketsTopMargin : CGFloat = 10
    let rocketsRightMargin : CGFloat = 20
    
    // MARK:- Helper variables -
    
    var referenceZoomScale : CGFloat = 0
    
    // MARK:- Initializer -
    
    required init(coder aDecoder: NSCoder) {
        
        rocketsView = UIImageView(image: UIImage(named: "rockets"))
        starsView = UIImageView (image: UIImage(named: "stars"))
        
        super.init(coder: aDecoder)
        
        self.contentSize = starsView.frame.size
        
        
        let screenBounds = UIScreen.mainScreen().bounds
        
        starsView.frame = CGRectMake(0, topMargin, CGRectGetWidth(starsView.frame), CGRectGetHeight(starsView.frame))
        
        rocketsView.frame = CGRectMake(CGRectGetWidth(screenBounds) - rocketsRightMargin - CGRectGetWidth(rocketsView.frame), rocketsTopMargin, CGRectGetWidth(rocketsView.frame), CGRectGetHeight(rocketsView.frame))
        
        self.addSubview(starsView)
        self.addSubview(rocketsView)
        
        self.delegate = self
        self.minimumZoomScale = 1.0
        self.maximumZoomScale = 8
    }

    // MARK:- Layout -
    
    override func setZoomScale(scale: CGFloat, animated: Bool) {
        super.setZoomScale(scale, animated: animated)
        referenceZoomScale = self.zoomScale
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        let visibleBounds = self.convertRect(self.bounds, toView: self.starsView)
        
        /*
        let maxVisibleX = CGRectGetMaxX(visibleBounds)
        let minVisibleX = CGRectGetMinX(visibleBounds)
        */
        
        let moonCenterX = CGRectGetMaxX(self.bounds) - rocketsRightMargin - CGRectGetWidth(rocketsView.frame) / 2
        let moonCenterY = self.contentOffset.y + 10 + CGRectGetHeight(rocketsView.frame) / 2
            
        rocketsView.center = CGPointMake(moonCenterX, CGRectGetHeight(rocketsView.frame) / 2 + rocketsTopMargin)
    }
    
    // MARK:- UIScrollviewDelegate -
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return starsView
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
        // redraw after zooming
        
        let s = scale * scrollView.window!.screen.scale
        starsView.contentScaleFactor = scale
    }
}
