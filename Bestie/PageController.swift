//
//  PageController.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/23/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import THTinderNavigationController_ssuchanowski

class PageController: UIViewController {
    
    var pageController: THTinderNavigationController!
    private var navItems: [UIView] = []
    private var navControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        self.pageController = THTinderNavigationController()
        self.pageController.paggedViewControllers = [
            storyBoard.instantiateViewControllerWithIdentifier("SettingsController"),
            storyBoard.instantiateViewControllerWithIdentifier("VoteController"),
            storyBoard.instantiateViewControllerWithIdentifier("BridgeController")
        ]
        self.pageController.navbarItemViews = [
            NavigationBarItem(namedImage: "Settings", special: false),
            NavigationBarItem(namedImage: "Face-Left", special: true),
            NavigationBarItem(namedImage: "Trophy", special: false),
        ]
        self.pageController.setCurrentPage(1, animated: true)
        
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
        
        self.view.addSubview(self.pageController.view)
    }
}
