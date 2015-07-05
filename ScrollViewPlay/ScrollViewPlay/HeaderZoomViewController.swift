//
//  HeaderZoomViewController.swift
//  ScrollViewPlay
//
//  Created by Teodor Patras on 02/07/15.
//  Copyright (c) 2015 Teodor Patras. All rights reserved.
//

import UIKit

class HeaderZoomViewController: UIViewController {
    
    
    @IBOutlet weak var scrollView: HeaderZoomScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.navigationItem.title = "Header view & Zooming";
    }
}
