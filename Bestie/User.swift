//
//  User.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/27/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

var currentUser: User!
var currentBatch: Batch!

import Mixpanel

class User {
    
    // MARK: Instance Variables
    var gender: String!
    var interested: String!
    var mixpanel: Mixpanel!
    var batch: Batch!
    var parse: PFUser!
    
    // MARK: Convenience Methods
    convenience init(_ user: PFUser) {
        self.init()
        
        self.gender = user["gender"] as? String
        self.interested = user["interested"] as? String
        self.parse = user
        self.mixpanel = Mixpanel.sharedInstance()
        
        self.loadBatch(nil)
    }
    
    // MARK: Class Methods
    class func register(callback: ((user: User) -> Void)!) {
       let mixpanel = Mixpanel.sharedInstance()
        
        PFAnonymousUtils.logInWithBlock { (object: PFUser?, error: NSError?) -> Void in
            if let user: PFUser = object {
                user.saveInBackground()
                
                currentUser = User(user)
                
                Installation.current().setUser(currentUser)
                currentUser.aliasMixpanel()
                
                callback?(user: currentUser)
            } else {
                ErrorHandler.handleParseError(error!)
                mixpanel.track("Mobile.User.Failed Authentication")
            }
        }
    }
    
    class func current() -> User! {
        if currentUser != nil {
            return currentUser
        }
        
        if let user = PFUser.currentUser() {
            currentUser = User(user)
            
            PFSession.getCurrentSessionInBackgroundWithBlock({ (session: PFSession?, error: NSError?) -> Void in
                if session == nil || error != nil {
                    ErrorHandler.handleParseError(error!)
                }
            })
            
            return currentUser
        } else {
            return nil
        }
    }
    
    class func logout() {
        currentBatch = nil
        currentUser = nil
        Mixpanel.sharedInstance().track("Mobile.User.Logout")
        PFUser.logOut()
    }
    
    // MARK: Instance Methods
    func logout() {
        User.logout()
    }
    
    func aliasMixpanel() {
        self.mixpanel.createAlias(self.parse.objectId, forDistinctID: self.mixpanel.distinctId)
    }
    
    func addBatch(batch: Batch) {
        let relation = self.parse.relationForKey("batches")
        
        self.batch = batch
        self.parse["batch"] = batch.parse
        
        relation.addObject(batch.parse)
        
        self.parse.saveInBackground()
    }
    
    func resetBatch() {
        currentBatch = nil
        
        self.batch = nil
        self.parse.removeObjectForKey("batch")
        self.parse.saveInBackground()
        Globals.batchUpdated()
    }
    
    func loadBatch(callback: (() -> Void)!) {
        if self.batch != nil {
            callback?()
        } else if currentBatch != nil {
            self.batch = currentBatch
            callback?()
        } else {
            let tmp = self.parse["batch"] as? PFObject
                
            tmp?.fetchIfNeededInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
                if let batch = object {
                    self.batch = Batch(batch)
                    currentBatch = self.batch
                    Globals.batchUpdated()
                    callback?()
                } else {
                    callback?()
                    ErrorHandler.handleParseError(error!)
                }
            })
        }
    }
    
    func changeGender(gender: String) {
        self.gender = gender
        self.parse["gender"] = gender
        self.parse.saveInBackground()
    }
    
    func changeInterest(gender: String) {
        self.interested = gender
        self.parse["interested"] = gender
        self.parse.saveInBackground()
    }
    
    func fetch(callback: (() -> Void)!) {
        if !self.parse.isDataAvailable() {
            self.loadBatch(callback)
            return
        }
        
        self.parse.fetchInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            if let user: PFObject = object {
                self.gender = user["gender"] as? String
                self.interested = user["interested"] as? String
                
                self.loadBatch(callback)
            } else {
                callback?()
                ErrorHandler.handleParseError(error!)
            }
        }
    }
    
    func pullSets(callback: (sets: [VoterSet]) -> Void) {
        PFCloud.callFunctionInBackground("feed", withParameters: nil) { (data: AnyObject?, error: NSError?) -> Void in
            if let objects: [PFObject] = data as? [PFObject] {
                var temp: [Image] = []
                var sets: [VoterSet] = []
                
                for object in objects {
                    temp.append(Image(object))
                }
                
                for images in temp.chunk(2) {
                    sets.append(VoterSet(images[0], images[1]))
                }
                
                callback(sets: sets)
            } else {
                callback(sets: [])
                ErrorHandler.handleParseError(error!)
            }
        }
    }
}