//
//  NestedScrollViewController.swift
//  ScrollViewPlay
//
//  Created by Teodor Patras on 05/07/15.
//  Copyright (c) 2015 Teodor Patras. All rights reserved.
//

import UIKit

class NestedScrollViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ScrollableCellDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var secondPageView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Nested scroll views"
        
        var frame = UIScreen.mainScreen().bounds
        frame.origin.x += frame.size.width
        
        secondPageView = UIView(frame: frame)
        
        secondPageView.backgroundColor = UIColor.redColor()
        scrollView.addSubview(secondPageView)
        
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.collectionViewLayout = DynamicCollectionLayout()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 2, scrollView.frame.size.height)
    }
    
    // MARK:- UICollectionView DataSource & Delegate -
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 100
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("scrollCell", forIndexPath: indexPath) as! ScrollableCell
        
        cell.dragView.backgroundColor = randomColor()
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.bounds.size.width, 60)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
    // MARK:- ScrollableCellDelegate -
    
    func scrollableCellDidBeginPulling(cell: ScrollableCell) {
        self.scrollView.scrollEnabled = false
        
        self.secondPageView.backgroundColor = cell.dragView.backgroundColor
    }
    
    func scrollableCellDidChangePullOffset(cell: ScrollableCell, offset: CGFloat) {
        self.scrollView.contentOffset = CGPointMake(offset, 0)
    }
    
    func scrollableCellDidEndPulling(cell: ScrollableCell) {
        self.scrollView.scrollEnabled = true
    }
    
    // MARK:- Helpers -
    
    func randomColor() -> UIColor{
        
        var randomRed:CGFloat = CGFloat(drand48())
        
        var randomGreen:CGFloat = CGFloat(drand48())
        
        var randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
}
