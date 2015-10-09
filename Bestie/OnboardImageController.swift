//
//  OnboardFirstImageController.swift
//  Bestie
//
//  Created by Brian Vallelunga on 10/5/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit
import TOMSMorphingLabel

class OnboardImageController: OnboardPageController {

    private var imageView = UIImageView()
    private var label = TOMSMorphingLabel()
    private var i: Int = 0
    private var strings: [String] = []
    private var timer: NSTimer!
    private var text: String {
        if i >= strings.count {
            i = 0
        }
        return strings[i++]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.label.font = UIFont(name: "Bariol", size: 34)
        self.label.minimumScaleFactor = 0.5
        self.label.numberOfLines = 0
        self.label.textAlignment = .Center
        self.label.morphingEnabled = false
        
        self.imageView.backgroundColor = UIColor.clearColor()
        self.imageView.contentMode = .ScaleAspectFit
        
        self.view.addSubview(self.label)
        self.view.addSubview(self.imageView)
    }
    
    deinit {
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
    }
    
    func cycleText() {
        self.label.text = self.text
    }
    
    func updateFrame(frame: CGRect, index: Int) {
        self.label.textColor = UIColor(red:1, green:0.42, blue:0.4, alpha:1)
        
        switch(index) {
            case 0:
                self.strings = Strings.onboardPage1
                self.label.textColor = UIColor(red:0.16, green:0.36, blue:0.51, alpha:1)
            
            case 1:
                self.strings = Strings.onboardPage2
                self.label.textColor = UIColor(red:0.16, green:0.36, blue:0.51, alpha:1)
            
            case 2:
                self.strings = Strings.onboardPage3
            
            default:
                self.strings = Strings.onboardPage4
        }
        
        self.view.frame = frame
        self.label.frame = CGRectMake(10, 40, frame.width-20, 70)
        self.imageView.frame = CGRectMake(0, 120, frame.width, frame.height - 120)
        self.imageView.image = UIImage(named: "Onboard-\(index)")
        self.cycleText()
        
        if self.strings.count > 1 {
            self.label.morphingEnabled = true
            self.timer = NSTimer.scheduledTimerWithTimeInterval(Globals.onboardChange, target: self,
                selector: Selector("cycleText"), userInfo: nil, repeats: true)
        }
    }

}
