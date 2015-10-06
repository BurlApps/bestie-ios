//
//  StateTracker.swift
//  Bestie
//
//  Created by Brian Vallelunga on 10/6/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class StateTracker {
    
    static var defaults = NSUserDefaults.standardUserDefaults()
    
    class func save() {
        self.defaults.synchronize()
    }
    
    class func setVersion(version: String) {
        self.defaults.setValue(version, forKey: "VersionNumber")
        self.save()
    }
    
    class func barsTutorial(had: Bool) {
        self.defaults.setBool(had, forKey: "BarsTutorial")
        self.save()
    }
    
    class func hadBarsTutorial() -> Bool {
        if let tutorial: Bool = self.defaults.valueForKey("BarsTutorial") as? Bool {
            return tutorial
        }
        
        return false
    }
    
    class func votingTutorial(had: Bool) {
        self.defaults.setBool(had, forKey: "VotingTutorial")
        self.save()
    }
    
    class func hadVotingTutorial() -> Bool {
        if let tutorial: Bool = self.defaults.valueForKey("VotingTutorial") as? Bool {
            return tutorial
        }
        
        return false
    }
}
