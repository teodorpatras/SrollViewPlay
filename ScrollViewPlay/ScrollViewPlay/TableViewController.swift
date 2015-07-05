//
//  TableViewController.swift
//  ScrollViewPlay
//
//  Created by Teodor Patras on 02/07/15.
//  Copyright (c) 2015 Teodor Patras. All rights reserved.
//

import UIKit

func statusAndNavigationBarHeights(controller : UINavigationController) -> CGFloat{
    return UIApplication.sharedApplication().statusBarFrame.height + controller.navigationBar.frame.size.height
}

class TableViewController: UITableViewController {

    let dataSource = [["title" : "Infinite scrolling", "segue" : "showInfiniteScrollView"],["title" : "Header View & Zooming", "segue" : "showHeaderZoomScrollView"], ["title" : "Nested scroll views", "segue" : "showNestedScrollViews"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title =  "Overview"
        self.navigationController?.navigationBar.translucent = false
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return dataSource.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = dataSource[indexPath.row]["title"]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier(dataSource[indexPath.row]["segue"], sender: nil)
    }
}
