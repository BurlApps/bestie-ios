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
    static var logoImage: NavigationBarItem!
    
    static let progressBarWidth: CGFloat = 10
    
    static let voterTextLabel: CGFloat = 50
    
    static let voterSetVerticalPadding: CGFloat = 6
    static let voterSetMiddlePadding: CGFloat = 5
    static let voterSetInterval = 0.4
    
    static let voterImageBorder: CGFloat = 1
    static let voterImageRadius: CGFloat = 8
    static let voterImagePop: CGFloat = 1.1
    static let voterImageInterval = 0.1
    
    class func switchLogoFace() {
        self.logoImage.switchFace()
    }
    
}
