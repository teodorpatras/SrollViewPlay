//
//  DynamicCollectionLayout.swift
//  ScrollViewPlay
//
//  Created by Teodor Patras on 05/07/15.
//  Copyright (c) 2015 Teodor Patras. All rights reserved.
//

import UIKit

class DynamicCollectionLayout: UICollectionViewFlowLayout {
 
    var animator : UIDynamicAnimator!
    
    override func prepareLayout() {
        super.prepareLayout()
        
        if animator == nil {
            animator = UIDynamicAnimator(collectionViewLayout: self)
            /*
                This needs to be optimised in a real life application
                use UIDynamicAnimator's
                
                func addBehavior(behavior: UIDynamicBehavior!)
                func removeBehavior(behavior: UIDynamicBehavior!)
            
                To add only the visible items at a given time and remove the other ones 
                which are not visible anymore
            
            */
            let contentSize = self.collectionViewContentSize()
            let items = super.layoutAttributesForElementsInRect(CGRectMake(0, 0, contentSize.width, contentSize.height)) as! [UICollectionViewLayoutAttributes]
            
            for item in items {
                let spring = UIAttachmentBehavior(item: item, attachedToAnchor: item.center)

                spring.length = 0
                spring.damping = 0.5
                spring.frequency = 0.8
                
                animator.addBehavior(spring)
            }
        }
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return animator.layoutAttributesForCellAtIndexPath(indexPath)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        return animator.itemsInRect(rect)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        let scrollDelta = newBounds.origin.y - self.collectionView!.bounds.origin.y
        let touchLocation = self.collectionView!.panGestureRecognizer.locationInView(self.collectionView!)
        
        for spring in animator.behaviors {
            let item = (spring as! UIAttachmentBehavior).items.first as! UICollectionViewLayoutAttributes
            
            let anchorPoint = (spring as! UIAttachmentBehavior).anchorPoint
            let distanceFromTouch = fabs(touchLocation.y - anchorPoint.y)
            let scrollResistance = distanceFromTouch / 750
            
            var center = item.center
            center.y += scrollDelta * scrollResistance
            item.center = center
            
            animator.updateItemUsingCurrentState(item)
        }
        
        return false
    }
    
}
