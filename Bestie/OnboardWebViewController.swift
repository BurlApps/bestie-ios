//
//  OnboardWebViewController.swift
//  Bestie
//
//  Created by Brian Vallelunga on 10/2/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class OnboardWebViewController: UIViewController {
    
    var url: NSURL!
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var navBar: UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navBar.translucent = true
        self.navBar.backgroundColor = UIColor.clearColor()
        self.navBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navBar.shadowImage = UIImage()

        self.webView.loadRequest(NSURLRequest(URL: self.url))
        self.webView.scalesPageToFit = true
    }

    @IBAction func closeTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
