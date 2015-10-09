//
//  WelcomeOnboardControllerViewController.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/30/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class WelcomeOnboardController: OnboardPageController, UIPageViewControllerDataSource,
UIPageViewControllerDelegate, TTTAttributedLabelDelegate {

    private var pageController: UIPageViewController!
    private var pages = 4
    private var nextPage = 0
    private var webUrl: NSURL!
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageContainer: UIView!
    @IBOutlet weak var legalLabel: TTTAttributedLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageController.view.backgroundColor = UIColor.clearColor()
        self.pageController.delegate = self
        self.pageController.dataSource = self
        
        for controller in self.pageController.view.subviews {
            if let scrollView = controller as? UIScrollView {
                scrollView.scrollEnabled = true
            }
            
            if let pageControl = controller as? UIPageControl {
                pageControl.hidden = true
            }
        }
        
        self.pageController.willMoveToParentViewController(self)
        self.addChildViewController(self.pageController)
        self.pageContainer.addSubview(self.pageController.view)
        self.pageController.didMoveToParentViewController(self)
        self.pageContainer.backgroundColor = UIColor.clearColor()
        
        self.separator.backgroundColor = Colors.onboardSeparator
        
        self.button.tintColor = UIColor.whiteColor()
        self.button.backgroundColor = Colors.batchSubmitButton
        self.button.layer.masksToBounds = true
        self.button.setTitle(Strings.onboardWelcomeButton, forState: .Normal)
        
        self.pageControl.numberOfPages = self.pages
        self.pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = Colors.lightGray
        self.pageControl.currentPageIndicatorTintColor = Colors.red
        self.pageControl.backgroundColor = UIColor.clearColor()
        self.pageControl.transform = CGAffineTransformMakeScale(1.4, 1.4)
        
        Config.sharedInstance { (config) -> Void in
            let tos = NSURL(string: config.termsURL)
            let privacy = NSURL(string: config.privacyURL)
            
            let tosRange = NSString(string: self.legalLabel.text!).rangeOfString("Terms of Service")
            let privacyRange = NSString(string: self.legalLabel.text!).rangeOfString("Privacy Policy")
            
            self.legalLabel.delegate = self
            self.legalLabel.addLinkToURL(tos, withRange: tosRange)
            self.legalLabel.addLinkToURL(privacy, withRange: privacyRange)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.showController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.pageController.view.frame = self.pageContainer.frame
        self.button.layer.cornerRadius = Globals.batchSubmitButtonRadius(self.button.frame.width)
        self.showController()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "webSegue" {
            (segue.destinationViewController as! OnboardWebViewController).url = self.webUrl
        }
    }
    
    @IBAction func tapped(sender: AnyObject) {
        if let controller = self.viewControllerAtIndex(++self.nextPage) {
            self.pageController.setViewControllers([controller], direction: .Forward, animated: true, completion: { (success: Bool) -> Void in
                self.pageViewController(self.pageController, didFinishAnimating: success, previousViewControllers: [controller], transitionCompleted: true)
            })
        } else {
            self.onboardController.nextController()
            Notifications().register()
        }
    }
    
    func showController() {
        if let controller = self.viewControllerAtIndex(0) {
            self.pageController.setViewControllers([controller], direction: .Forward, animated: false, completion: { (success: Bool) -> Void in
                self.pageViewController(self.pageController, didFinishAnimating: success, previousViewControllers: [controller], transitionCompleted: true)
            })
        }
    }
    
    func createPage(index: Int) -> OnboardImageController {
        let page = OnboardImageController()
        
        page.updateFrame(self.pageContainer.frame, index: index)
        page.pageIndex = index
        
        return page
    }
    
    
    // MARK: Page View Controller Data Source
    func viewControllerAtIndex(index: Int) -> OnboardImageController! {
        if self.pages == 0 || index >= self.pages {
            return nil
        }
        
        self.onboardController.mixpanel.track("Mobile.Onboard.Welcome.\(index)")
        
        return self.createPage(index)
    }
    
    // MARK: Page View Controller Data Source
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        self.nextPage = (pendingViewControllers.first as! OnboardImageController).pageIndex
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished && completed {
            self.pageControl.currentPage = self.nextPage
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! OnboardImageController).pageIndex
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        return self.viewControllerAtIndex(index - 1)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! OnboardImageController).pageIndex
        
        if index == NSNotFound || (index + 1) == self.pages {
            return nil
        }
        
        return self.viewControllerAtIndex(index + 1)
    }
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        self.webUrl = url
        self.performSegueWithIdentifier("webSegue", sender: self)
    }
    
}
