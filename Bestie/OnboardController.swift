
//
//  OnboardControllerViewController.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/30/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class OnboardController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var user: User!
    var nextPage = 1
    private var currentPage = 0
    private var controllers: [OnboardPageController] = []
    private var storyBoard = UIStoryboard(name: "Main", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundView = UIView(frame: self.view.frame)
        let image = UIImage(named: "HeaderBackground")
        
        backgroundView.backgroundColor = UIColor(patternImage: image!)
        backgroundView.alpha = Globals.onboardAlpha
        self.view.insertSubview(backgroundView, atIndex: 0)
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.dataSource = self
        self.delegate = self
        
        for controller in self.view.subviews {
            if let scrollView = controller as? UIScrollView {
                scrollView.scrollEnabled = false
            }
        }
        
        self.createPage("WelcomeController")
        self.createPage("GenderController")
        self.createPage("InterestController")
        
        Config.sharedInstance { (config) -> Void in
            self.nextPage = config.onboardNext
            
            if self.nextPage == -1 {
                self.createPage("DecisionController")
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.user = User.current()
        
        if self.user != nil && self.user.gender != nil && self.user.interested != nil {
            self.performSegueWithIdentifier("finishedSegue", sender: self)
        } else {
            User.register({ (user) -> Void in
                self.user = user
            })
            
            self.showController()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        (segue.destinationViewController as! PageController).startingPage = self.nextPage
    }
    
    func createPage(name: String) {
        let page = self.storyBoard.instantiateViewControllerWithIdentifier(name) as? OnboardPageController
        
        page?.pageIndex = self.controllers.count
        page?.onboardController = self
        
        self.controllers.append(page!)
    }
    
    func nextController() {
        self.currentPage += 1
        
        if self.currentPage >= self.controllers.count {
            self.currentPage = 0
            self.performSegueWithIdentifier("finishedSegue", sender: self)
            
            let properties = [
                "gender": self.user.gender,
                "interested": self.user.interested
            ]
            
            self.user.mixpanel.people.set(properties)
            self.user.mixpanel.track("Mobile.User.Registered", properties: properties)
            self.user.mixpanel.track("Mobile.Onboard.Next", properties: [
                "next": self.nextPage == 1 ? "voter" : "upload"
            ])
        } else {
            self.showController()
        }
    }
    
    func showController() {
        if let controller = self.viewControllerAtIndex(self.currentPage) {
            self.setViewControllers([controller], direction: .Forward, animated: self.currentPage > 0, completion: nil)
        }
    }
    
    func viewControllerAtIndex(index: Int) -> OnboardPageController! {
        if index == NSNotFound && index > self.controllers.count {
            return nil
        }
        
        return self.controllers[index]
    }
    

    // MARK: Page View Controller Data Source
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! OnboardPageController).pageIndex
        return self.viewControllerAtIndex(index - 1)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! OnboardPageController).pageIndex
        return self.viewControllerAtIndex(index + 1)
    }
}
