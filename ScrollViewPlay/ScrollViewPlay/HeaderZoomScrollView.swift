//
//  HeaderZoomScrollView.swift
//  ScrollViewPlay
//
//  Created by Teodor Patras on 02/07/15.
//  Copyright (c) 2015 Teodor Patras. All rights reserved.
//

import UIKit

class HeaderZoomScrollView: UIScrollView {

    
    // MARK:- Subviews -
    
    let rocketsView : UIImageView
    let starsView : UIImageView
    
    // MARK:- Constants -
    
    let topMargin : CGFloat = -64
    let rocketsTopMargin : CGFloat = -54
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
    }

    // MARK:- Layout -
    
    override func setZoomScale(scale: CGFloat, animated: Bool) {
        super.setZoomScale(scale, animated: animated)
        referenceZoomScale = self.zoomScale
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        let maxVisibleX = CGRectGetMaxX(self.bounds)
        let minVisibleX = CGRectGetMinX(self.bounds)
        
        let moonCenterX = maxVisibleX - rocketsRightMargin - CGRectGetWidth(rocketsView.frame) / 2
        let moonCenterY = self.contentOffset.y + 10 + CGRectGetHeight(rocketsView.frame) / 2
            
        rocketsView.center = CGPointMake(moonCenterX, CGRectGetHeight(rocketsView.frame) / 2 + rocketsTopMargin)
    }
    
}
