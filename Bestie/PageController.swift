//
//  PageController.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/23/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import THTinderNavigationController_ssuchanowski

class PageController: UIViewController {
    
    var startingPage: Int = 1
    var pageController: THTinderNavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let settingsController = storyBoard.instantiateViewControllerWithIdentifier("SettingsController") as! SettingsController
        let voterController = storyBoard.instantiateViewControllerWithIdentifier("VoteController") as! VoteController
        let bridgeController = storyBoard.instantiateViewControllerWithIdentifier("BridgeController") as! BridgeController
        
        self.navigationController?.navigationBarHidden = true
        
        self.pageController = THTinderNavigationController()
        
        self.pageController.paggedViewControllers = [
            settingsController, voterController, bridgeController
        ]
        
        self.pageController.navbarItemViews = [
            NavigationBarItem(namedImage: "Settings", special: false),
            NavigationBarItem(namedImage: "Face-Left", special: true),
            NavigationBarItem(namedImage: "Trophy", special: false),
        ]
        
        self.pageController.view.backgroundColor = UIColor.clearColor()
        self.pageController.setCurrentPage(self.startingPage, animated: true)
        self.view.addSubview(self.pageController.view)
        
        for view in self.pageController.view.subviews {
            
            if view.isKindOfClass(THTinderNavigationBar) {
                let navBar = view as! THTinderNavigationBar
                let navBorder = UIView(frame: CGRectMake(0, navBar.frame.height, navBar.frame.width, 1))
                
                navBorder.backgroundColor = Colors.navBar
                navBar.addSubview(navBorder)
                
                navBar.shadowImage = UIImage()
                navBar.translucent = false
                navBar.setBackgroundImage(nil, forBarMetrics: .Default)
                navBar.barTintColor = UIColor.whiteColor()
            }
        }
        
        Globals.pageController = self
        Globals.logoImage = self.pageController.navbarItemViews[1] as! NavigationBarItem
    }
}
