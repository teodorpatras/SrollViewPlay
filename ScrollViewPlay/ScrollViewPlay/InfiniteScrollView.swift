//
//  InfiniteScrollView.swift
//  ScrollViewPlay
//
//  Created by Teodor Patras on 02/07/15.
//  Copyright (c) 2015 Teodor Patras. All rights reserved.
//

import UIKit

class InfiniteScrollView: UIScrollView {
    
    let containerView : UIView
    let imageNames = ["rocket1", "rocket4", "rocket2", "rocket3"]
    var imageViews = [UIImageView]()
    var visibleImageViews = [UIImageView]()
    
    required init(coder aDecoder: NSCoder) {

        containerView = UIView()
        
        super.init(coder: aDecoder)
        
        self.contentSize = CGSizeMake(5000, UIScreen.mainScreen().bounds.height - 128)
        containerView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height * 0.7)
        self.addSubview(self.containerView)

        var actualSize : CGFloat = 0
        var imageView : UIImageView
        
        for name in imageNames
        {
            imageView = UIImageView(image: UIImage(named: name))
            actualSize += CGRectGetWidth(imageView.frame)
            imageViews.append(imageView)
        }
        
        /* this should only work if all the images place side by side would
        not fit within the width of the scroll view */
        
        if actualSize <= CGRectGetWidth(self.bounds) {
            self.scrollEnabled = false
            self.bounces = false
        }
        
    }
    
    // MARK:- Layout -
    
    func recenterIfNecessary ()
    {
        let centerOffsetX = (self.contentSize.width - self.bounds.size.width) / 2
        let distanceFromCenter = fabs(self.contentOffset.x - centerOffsetX)
        
        if distanceFromCenter > self.contentSize.width / 4 {
            
            
            // move all the views by the same amount so they appear still
            
            for imageView in self.visibleImageViews
            {
                var center = self.containerView.convertPoint(imageView.center, toView: self)
                center.x += centerOffsetX - self.contentOffset.x
                
                imageView.center = self.convertPoint(center, toView: self.containerView)
            }
            
            self.contentOffset = CGPointMake(centerOffsetX, self.contentOffset.y)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.recenterIfNecessary()
        
        // tile content in visible bounds
        
        let visibleBounds = self.convertRect(self.bounds, toView: self.containerView)
        let minVisX = CGRectGetMinX(visibleBounds)
        let maxVisX = CGRectGetMaxX(visibleBounds)
        
        self.tileFromMinX(minVisX, toMaxX: maxVisX)
    }
    
    // MARK:- UIImageViews Tiling -
    
    
    func placeImageViewOnRight(imageView : UIImageView, rightEdge : CGFloat) -> CGFloat {
        
        var frame = imageView.frame
        frame.origin.x = rightEdge
        frame.origin.y = CGRectGetHeight(self.containerView.bounds) - frame.size.height
        imageView.frame = frame
        
        self.containerView.addSubview(imageView)
        self.visibleImageViews.append(imageView)
        
        return CGRectGetMaxX(frame)
    }
    
    func placeImageViewOnLeft(imageView : UIImageView, leftEdge : CGFloat) -> CGFloat {
        
        var frame = imageView.frame
        frame.origin.x = leftEdge - CGRectGetWidth(frame)
        frame.origin.y = CGRectGetHeight(self.containerView.bounds) - frame.size.height
        imageView.frame = frame
        
        self.containerView.addSubview(imageView)
        self.visibleImageViews.insert(imageView, atIndex: 0)
        
        return CGRectGetMinX(frame)
    }
    
    func tileFromMinX(minVisX : CGFloat, toMaxX maxX: CGFloat) {
        
        
        // place the first image
        
        if visibleImageViews.count == 0 {
            var imageView = imageViews.removeAtIndex(0)
            self.placeImageViewOnRight(imageView, rightEdge: minVisX)
        }
        
        
        // place missing images on the right edge
        
        var shouldPlaceSomeMore = true
        var newXOrigin = CGRectGetMaxX(self.visibleImageViews.last!.frame)
        
        while shouldPlaceSomeMore
        {
            shouldPlaceSomeMore = false
            if newXOrigin < maxX
            {
                if let iv = imageViews.last
                {
                    newXOrigin = self.placeImageViewOnRight(iv, rightEdge: newXOrigin)
                    imageViews.removeLast()
                    shouldPlaceSomeMore = newXOrigin < maxX
                }
            }
        }
        
        
        // place missing images on the left edge
        
        shouldPlaceSomeMore = true
        newXOrigin = CGRectGetMinX(self.visibleImageViews.first!.frame)
        
        while shouldPlaceSomeMore
        {
            shouldPlaceSomeMore = false
            if newXOrigin > minVisX {
                if let iv = imageViews.first
                {
                    newXOrigin = self.placeImageViewOnLeft(iv, leftEdge: newXOrigin)
                    imageViews.removeAtIndex(0)
                    shouldPlaceSomeMore = newXOrigin > minVisX
                }
            }
        }
        
        // remove images that have fallen over the right edge
        
        var shouldRemove = true
        
        while shouldRemove
        {
            shouldRemove = false
            if let iv = visibleImageViews.last
            {
                if CGRectGetMinX(iv.frame) > maxX {
                    imageViews.append(iv)
                    iv.removeFromSuperview()
                    shouldRemove = true
                    visibleImageViews.removeLast()
                }
            }
        }
        
        // remove images that have fallen over the left edge
        
        shouldRemove = true
        
        while shouldRemove
        {
            shouldRemove = false
            
            if let iv = visibleImageViews.first
            {
                if CGRectGetMaxX(iv.frame) < minVisX
                {
                    imageViews.insert(iv, atIndex: 0)
                    iv.removeFromSuperview()
                    shouldRemove = true
                    visibleImageViews.removeAtIndex(0)
                }
            }
        }

    }
    
}
