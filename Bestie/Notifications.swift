//
//  Notifications.swift
//  Bestie
//
//  Created by Brian Vallelunga on 10/7/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import UIKit

class Notifications: NSObject {
    
    var enabled = false
    var application = UIApplication.sharedApplication()
    
    override init() {
        if self.application.respondsToSelector(Selector("isRegisteredForRemoteNotifications")) {
            self.enabled = self.application.isRegisteredForRemoteNotifications()
        }  else {
            self.enabled = self.application.enabledRemoteNotificationTypes() != .None
        }
    }
    
    func register() {
        if self.application.respondsToSelector(Selector("registerUserNotificationSettings:")) {
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            self.application.registerUserNotificationSettings(settings)
            self.application.registerForRemoteNotifications()
        } else {
            self.application.registerForRemoteNotificationTypes([.Alert, .Badge, .Sound])
        }
    }
}