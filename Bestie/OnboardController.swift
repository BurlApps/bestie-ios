//
//  OnboardController.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/27/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit
import Onboard

class OnboardController: UIViewController {
    
    private var user: User!
    private var screens: [OnboardingContentViewController] = []
    private var contentController: OnboardingViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Globals.onboardController = self
        
        self.user = User.current()
        
        if self.user == nil {
            self.contentController = OnboardingViewController(backgroundImage: UIImage(),
                contents: self.createScreens())
            
            self.contentController.shouldBlurBackground = false
            self.contentController.shouldMaskBackground = false
            self.contentController.shouldFadeTransitions = false
            self.contentController.bodyTextColor = Colors.onboardText
            self.contentController.pageControl.currentPageIndicatorTintColor = Colors.onboardIndicator
            self.contentController.pageControl.pageIndicatorTintColor = Colors.onboardIndicatorBackground
            self.contentController.view.frame = self.view.frame
            
            self.view.addSubview(self.contentController.view)
            
            User.register("male", interested: "female", callback: nil)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.user != nil {
            self.performSegueWithIdentifier("onboardedSegue", sender: self)
        } else {
            self.contentController.setCurrentPage(self.screens.first)
        }
    }
    
    func createScreens() -> [OnboardingContentViewController] {
        self.screens.append(self.screen1())
        self.screens.append(self.screen2())
        
        return self.screens
    }

    func screen1() -> OnboardingContentViewController {
        return OnboardingContentViewController(title: "1", body: "Hello World", image: nil, buttonText: nil, action: nil)
    }
    
    func screen2() -> OnboardingContentViewController {
        let screen = OnboardingContentViewController()
        
        screen.viewDidAppearBlock = {
            self.performSegueWithIdentifier("onboardedAnimationSegue", sender: self)
        }
        
        return screen
    }
}
