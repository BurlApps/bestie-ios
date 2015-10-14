//
//  Installation.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/27/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import Mixpanel

class Installation {
    
    // MARK: Instance Variables
    var id: String!
    var parse: PFInstallation!
    
    // MARK: Convenience Methods
    convenience init(_ object: PFInstallation) {
        self.init()
        
        self.id = object.objectId
        self.parse = object
    }
    
    // MARK: Class Methods
    class func current() -> Installation {
        return Installation(PFInstallation.currentInstallation())
    }
    
    class func startup() -> Installation {
        let install = PFInstallation.currentInstallation()
        install.setObject(Globals.appVersion(), forKey: "appVersionNumber")
        install.setObject(Globals.appBuildVersion(), forKey: "appVersionBuild")
        install.saveInBackground()
        return Installation(install)
    }
    
    // MARK: Instance Methods
    func setDeviceToken(token: NSData) {
        self.parse.setDeviceTokenFromData(token)
        self.parse.saveInBackground()
        
        Mixpanel.sharedInstance().people.addPushDeviceToken(token)
    }
    
    func setUser(user: User) {
        self.parse["user"] = user.parse
        self.parse.saveInBackground()
    }
    
    func setBadge(badge: Int) {
        self.parse.badge = badge
        self.parse.saveEventually()
    }
    
    func decrementBadge() {
        if self.parse.badge != 0 {
            self.parse.badge--
            self.parse.saveEventually()
        }
    }
    
    func clearBadge() {
        if self.parse.badge != 0 {
            self.parse.badge = 0
            self.parse.saveEventually()
        }
    }
}