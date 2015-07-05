
//
//  ScrollableCell.swift
//  ScrollViewPlay
//
//  Created by Teodor Patras on 05/07/15.
//  Copyright (c) 2015 Teodor Patras. All rights reserved.
//

import UIKit

class ScrollableCell: UICollectionViewCell, UIScrollViewDelegate {

    
    var scrollView: UIScrollView!
    var dragView: UIView!
    var label : UILabel!
    
    weak var delegate : ScrollableCellDelegate?
    
    var pulling = false
    var deceleratingBackToZero = false
    
    var decelerationDistanceRatio : CGFloat = 0
    let pullThreshold : CGFloat = 100
    
    override func awakeFromNib() {
        
        scrollView = UIScrollView()
        dragView = UIView()
        label = UILabel()
        
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.backgroundColor = UIColor.clearColor()
        label.text = "Slide from right to left"
        label.textAlignment = NSTextAlignment.Center
    
        self.scrollView.delegate = self
        self.scrollView.pagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        
        self.addSubview(self.scrollView)
        self.dragView.addSubview(label)
        self.scrollView.addSubview(dragView)
    }
    
    override func layoutSubviews() {
        
        let contentView = self.contentView
        let bounds = self.bounds
        let pageWidth = bounds.size.width + pullThreshold
        
        self.scrollView.frame = CGRectMake(0, 0, pageWidth, bounds.size.height)
        self.scrollView.contentSize = CGSizeMake(pageWidth * 2, bounds.size.height)
        
        dragView.frame = bounds
        label.frame = bounds
    }
    
    // MARK:- UIScrollViewDelegate -
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        
        if offset > pullThreshold && !pulling {
            // did start pulling
            self.delegate?.scrollableCellDidBeginPulling(self)
            pulling = true
        }
        
        if pulling {
            var pullOffset = CGFloat(0)
            
            if deceleratingBackToZero{
                pullOffset = offset * decelerationDistanceRatio
            } else {
                pullOffset = max(0, offset - pullThreshold)
            }
            
            self.delegate?.scrollableCellDidChangePullOffset(self, offset: pullOffset)
            self.dragView.transform = CGAffineTransformMakeTranslation(pullOffset, 0)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.scrollingEnded()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollingEnded()
        }
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let offset = scrollView.contentOffset.x
        
        if targetContentOffset.memory.x == 0 && offset > 0 {
            deceleratingBackToZero = true
            let pullOffset = max(0, offset - pullThreshold)
            decelerationDistanceRatio = pullOffset / offset
        }
    }
    
    func scrollingEnded ()
    {
        deceleratingBackToZero = false
        pulling = false
        self.delegate?.scrollableCellDidEndPulling(self)
        self.scrollView.contentOffset = CGPointZero
        self.dragView.transform = CGAffineTransformIdentity
    }
}

@objc protocol ScrollableCellDelegate {
    func scrollableCellDidBeginPulling(cell : ScrollableCell)
    func scrollableCellDidChangePullOffset(cell : ScrollableCell, offset : CGFloat)
    func scrollableCellDidEndPulling(cell : ScrollableCell)
}
