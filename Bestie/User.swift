//
//  User.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/27/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

var currentUser: User!
var currentBatch: Batch!

class User {
    
    // MARK: Instance Variables
    var gender: String!
    var interested: String!
    var batch: Batch!
    var parse: PFUser!
    
    // MARK: Convenience Methods
    convenience init(_ user: PFUser) {
        self.init()
        
        self.gender = user["gender"] as? String
        self.interested = user["interested"] as? String
        self.parse = user
        
        self.loadBatch(nil)
    }
    
    // MARK: Class Methods
    class func register(gender: String, interested: String, callback: ((user: User) -> Void)!) {
        PFAnonymousUtils.logInWithBlock { (object: PFUser?, error: NSError?) -> Void in
            if let user: PFUser = object {
                user["gender"] = gender
                user["interested"] = interested
                user.saveInBackground()
                
                let current = User(user)
                
                Installation.current().setUser(current)
                
                callback?(user: current)
            } else {
                ErrorHandler.handleParseError(error!)
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
        PFUser.logOut()
    }
    
    // MARK: Instance Methods
    func logout() {
        User.logout()
    }
    
    func addBatch(batch: Batch) {
        self.batch = batch
        self.parse["batch"] = batch.parse
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
            self.batch.fetch({ () -> Void in
                Globals.batchUpdated()
                callback?()
            })
            
            return
        }
        
        if currentBatch != nil {
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
    
    func pullSets(callback: (sets: [[Image]]) -> Void) {
        let query = PFQuery(className: "Image")
        
        query.whereKey("active", equalTo: true)
        query.whereKey("voters", notEqualTo: self.parse)
        query.whereKey("creator", notEqualTo: self.parse)
        query.whereKey("gender", equalTo: self.interested)
        query.cachePolicy = .NetworkOnly
        query.limit = 50
        
        if arc4random_uniform(2) == 1 {
            query.addAscendingOrder("objectId")
        } else {
            query.addDescendingOrder("objectId")
        }
        
        query.findObjectsInBackgroundWithBlock { (data: [PFObject]?, error: NSError?) -> Void in
            if let objects: [PFObject] = data?.shuffle() {
                var temp: [Image] = []
                
                for object in objects {
                    temp.append(Image(object))
                }
                
                callback(sets: temp.chunk(2))
            } else {
                callback(sets: [])
                ErrorHandler.handleParseError(error!)
            }
        }
        
    }
}