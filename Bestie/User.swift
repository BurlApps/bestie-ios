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
        
        if self.gender == nil {
            self.changeGender("female")
        }
        
        if self.interested == nil {
            self.changeInterest("both", callback: nil)
        }
        
        self.loadBatch(nil)
    }
    
    // MARK: Class Methods
    class func register(gender: String, interest: String, callback: ((user: User) -> Void)!) {
       let mixpanel = Mixpanel.sharedInstance()
        
        PFAnonymousUtils.logInWithBlock { (object: PFUser?, error: NSError?) -> Void in
            if let user: PFUser = object {
                currentUser = User(user)
                
                Installation.current().setUser(currentUser)
                currentUser.aliasMixpanel()
                currentUser.changeGenderInterest(gender, interest: interest)
            
                callback?(user: currentUser)
                
                currentUser.mixpanel.track("Mobile.User.Registered", properties: [
                    "Gender": gender,
                    "Interested": interest
                ])
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
        let mixpanel = Mixpanel.sharedInstance()
        
        currentBatch = nil
        currentUser = nil
        
        mixpanel.track("Mobile.User.Logout")
        mixpanel.reset()
        
        StateTracker.votingTutorial(false)
        StateTracker.barsTutorial(false)
        
        PFUser.logOut()
    }
    
    // MARK: Instance Methods    
    func logout() {
        User.logout()
    }
    
    func aliasMixpanel() {
        self.mixpanel.people.set("ID", to: self.parse.objectId)
        self.mixpanel.createAlias(self.parse.objectId, forDistinctID: self.mixpanel.distinctId)
    }
    
    func addBatch(batch: Batch, callback: (() -> Void)!) {
        let relation = self.parse.relationForKey("batches")
        
        self.batch = batch
        self.parse["batch"] = batch.parse
        
        currentBatch = batch
        
        relation.addObject(batch.parse)
        
        self.parse.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                callback?()
            } else {
                ErrorHandler.handleParseError(error!)
            }
        }
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
        } else if let tmp = self.parse["batch"] as? PFObject {
            tmp.fetchIfNeededInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
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
        } else {
            callback?()
        }
    }
    
    func changeGenderInterest(gender: String, interest: String) {
        self.gender = gender
        self.interested = interest
        
        self.parse["gender"] = gender
        self.parse["interested"] = interested
        self.parse.saveInBackground()
        
        self.mixpanel.people.set([
            "Gender": gender,
            "Interested": interest
        ])
    }
    
    func changeGender(gender: String) {
        self.gender = gender
        self.parse["gender"] = gender
        self.parse.saveInBackground()
        
        self.mixpanel.people.set([
            "Gender": gender
        ])
    }
    
    func changeInterest(gender: String, callback: (() -> Void)!) {
        self.interested = gender
        self.parse["interested"] = gender
        self.parse.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                callback?()
            } else {
                ErrorHandler.handleParseError(error!)
            }
        }
        
        self.mixpanel.people.set([
            "Interested": gender
        ])
        self.mixpanel.track("Mobile.User.Interest.Changed")
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
        autoreleasepool {
            PFCloud.callFunctionInBackground("feed", withParameters: nil) { (data: AnyObject?, error: NSError?) -> Void in
                if let objects: [PFObject] = data as? [PFObject] {
                    var sets: [VoterSet] = []
                    
                    for images in objects.chunk(2) {
                        sets.append(VoterSet(Image(images[0]), Image(images[1])))
                    }
                    
                    callback(sets: sets)
                } else {
                    callback(sets: [])
                    ErrorHandler.handleParseError(error!)
                }
            }
        }
    }
}