
//
//  NavNotification.swift
//  Bestie
//
//  Created by Brian Vallelunga on 10/6/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

import CWStatusBarNotification
import AudioToolbox

class NavNotification: NSObject {
    
    class func show(text: String, duration: NSTimeInterval = 3, callback: (() -> Void)! = nil) {
        let notification = CWStatusBarNotification()
        
        notification.notificationAnimationInStyle = .Top
        notification.notificationAnimationOutStyle = .Top
        notification.notificationAnimationType = .Overlay
        notification.notificationStyle = .NavigationBarNotification
        notification.notificationLabelBackgroundColor = Colors.red
        notification.notificationLabelTextColor = UIColor.whiteColor()
        notification.notificationLabelFont = UIFont(name: "Bariol-Bold", size: 22)
        notification.notificationTappedBlock = {
            notification.dismissNotification()
            callback?()
        }
        
        AudioServicesPlayAlertSound(UInt32(kSystemSoundID_Vibrate))
        notification.displayNotificationWithMessage(text, forDuration: duration)
    }

}
