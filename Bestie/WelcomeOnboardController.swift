//
//  WelcomeOnboardControllerViewController.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/30/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class WelcomeOnboardController: OnboardPageController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    private var pageController: UIPageViewController!
    private var pages = 2
    private var nextPage = 0
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageContainer: UIView!
    
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
        
        self.addChildViewController(self.pageController)
        self.pageContainer.addSubview(self.pageController.view)
        
        self.pageController.didMoveToParentViewController(self)
        self.pageContainer.backgroundColor = UIColor.clearColor()
        
        self.separator.backgroundColor = Colors.settingsBackground
        
        self.button.tintColor = UIColor.whiteColor()
        self.button.backgroundColor = Colors.batchSubmitButton
        self.button.layer.cornerRadius = Globals.batchSubmitButtonRadius
        self.button.layer.masksToBounds = true
        
        self.pageControl.numberOfPages = self.pages
        self.pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = Colors.lightGray
        self.pageControl.currentPageIndicatorTintColor = Colors.red
        self.pageControl.backgroundColor = UIColor.clearColor()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.showController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.pageController.view.frame = self.pageContainer.frame
        self.showController()
    }
    
    @IBAction func tapped(sender: AnyObject) {        
        self.onboardController.nextController()
    }
    
    func createPage(index: Int) -> OnboardImageController {
        let page = OnboardImageController()
        
        page.pageIndex = index
        page.view.frame = self.pageContainer.frame
        page.imageView.image = UIImage(named: "Onboard-\(index)")
        page.imageView.frame = CGRectMake(0, 0,
            self.pageContainer.frame.width, self.pageContainer.frame.height)
        
        return page
    }
    
    func showController() {
        if let controller = self.viewControllerAtIndex(0) {
            self.pageController.setViewControllers([controller], direction:
                .Forward, animated: false, completion: nil)
        }
    }
    
    
    // MARK: Page View Controller Data Source
    func viewControllerAtIndex(index: Int) -> OnboardImageController! {
        if self.pages == 0 || index >= self.pages {
            return nil
        }
        
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
    
}
