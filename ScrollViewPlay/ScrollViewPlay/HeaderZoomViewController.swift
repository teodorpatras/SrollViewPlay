//
//  HeaderZoomViewController.swift
//  ScrollViewPlay
//
//  Created by Teodor Patras on 02/07/15.
//  Copyright (c) 2015 Teodor Patras. All rights reserved.
//

import UIKit

class HeaderZoomViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollView: HeaderZoomScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
       self.navigationItem.title = "Header view & Zooming";
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return (scrollView as! HeaderZoomScrollView).starsView
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let scrollViewFrame = self.scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight)
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 1.0
        
        scrollView.zoomScale = minScale
    }
}
