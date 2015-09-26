//
//  ResultsController.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/25/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class ResultsController: UITableViewController {
    
    private let reuseIdentifier = "cell"
    private var images: [UIImage] = [UIImage(),UIImage(),UIImage()]
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let percent = Globals.resultsFirstPhotoPercentHeight
        self.tableView.tableHeaderView!.frame.size.height = self.view.frame.height * percent
        self.tableView.tableHeaderView = self.tableView.tableHeaderView
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.images.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.tableView.frame.height/1.2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: ImageTableCell! = tableView.dequeueReusableCellWithIdentifier(self.reuseIdentifier) as? ImageTableCell
        
        if cell == nil {
            cell = ImageTableCell()
        }
        
        return cell
    }
}
