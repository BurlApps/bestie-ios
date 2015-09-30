//
//  Globals.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/24/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class Globals {
    
    static var pageController: PageController!
    static var onboardController: OnboardController!
    static var bridgeController: BridgeController!
    static var voterController: VoteController!
    static var logoImage: NavigationBarItem!
    
    static let progressBarWidth: CGFloat = 7
    
    static let spinner: CGFloat = 100
    
    static let voterTextLabel: CGFloat = 50
    static let voterTextLabelBig: CGFloat = 150
    static let voterTextLabelInterval: NSTimeInterval = 0.5
    
    static let voterSetVerticalPadding: CGFloat = 6
    static let voterSetMiddlePadding: CGFloat = 5
    static let voterSetInterval: NSTimeInterval = 0.2
    
    static let voterImageBorder: CGFloat = 1
    static let voterImageRadius: CGFloat = 8
    static let voterImagePop: CGFloat = 1.1
    static let voterImageInterval: NSTimeInterval = 0.1

    static let batchCellRadius: CGFloat = 5
    static let batchPlusCellBorder: CGFloat = 2
    static let batchImageCellBorder: CGFloat = 1
    
    static let batchSubmitButtonRadius: CGFloat = 23
    
    static let resultsFirstPhotoPercentHeight: CGFloat = 0.85
    
    static let shareCardSize: CGFloat = 600
    static let shareCardContainerHeight: CGFloat = 560
    static let shareCardBackgroundAlpha: CGFloat = 0.2
    static let bridgeBackgroundAlpha: CGFloat = 0.08
    
    
    class func switchLogoFace() {
        self.logoImage.switchFace()
    }
    
    class func reloadBridgeController() {
        if self.bridgeController != nil {
            self.bridgeController.reloadController()
        }
    }
    
    class func slideToVotingScreen() {
        if self.pageController != nil {
            self.pageController.pageController.setCurrentPage(1, animated: true)
        }
    }
    
    class func showOnboarding() {
        if self.onboardController != nil {
            self.onboardController.resetController()
            self.onboardController.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    class func reloadUser() {        
        if let user = User.current() {
            user.fetch({ () -> Void in
                if user.batch != nil {
                    user.batch.fetch({ () -> Void in
                        self.reloadBridgeController()
                    })
                }
            })
        }
    }
    
    class func batchUpdated() {
        if self.voterController != nil {
            self.voterController.progressBarUpdate()
        }
        
        self.reloadBridgeController()
    }
    
    class func appBuildVersion() -> String {
        let infoDictionary = NSBundle.mainBundle().infoDictionary!
        let version = infoDictionary["CFBundleShortVersionString"] as! NSString
        let build = infoDictionary[String(kCFBundleVersionKey)] as! NSString
        
        return "\(version) - \(build)"
    }
    
    class func appVersion() -> String {
        let infoDictionary = NSBundle.mainBundle().infoDictionary!
        
        return infoDictionary["CFBundleShortVersionString"] as! String
    }
    
}
