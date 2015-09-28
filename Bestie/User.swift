//
//  User.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/27/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

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
        
        (user["batch"] as? PFObject)?.fetchIfNeededInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
            if let batch = object {
                self.batch = Batch(batch)
            } else {
                ErrorHandler.handleParseError(error!)
            }
        })
    }
    
    // MARK: Class Methods
    class func register(callback: ((user: User) -> Void)!) {
        PFAnonymousUtils.logInWithBlock { (user: PFUser?, error: NSError?) -> Void in            
            if user != nil && error == nil {
                let current = User(user!)
                
                Installation.current().setUser(current)
                
                callback?(user: current)
            } else {
                ErrorHandler.handleParseError(error!)
            }
        }
    }
    
    class func current() -> User! {
        if let user = PFUser.currentUser() {
            PFSession.getCurrentSessionInBackgroundWithBlock({ (session: PFSession?, error: NSError?) -> Void in
                if session == nil || error != nil {
                    ErrorHandler.handleParseError(error!)
                }
            })
            
            return User(user)
        } else {
            return nil
        }
    }
    
    class func logout() {
        PFUser.logOut()
    }
    
    // MARK: Instance Methods
    func logout() {
        PFUser.logOut()
    }
    
    func fetch(callback: (() -> Void)!) {
        if !self.parse.isDataAvailable() {
            callback?()
            return
        }
        
        self.parse.fetchInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            if let user: PFObject = object {
                let tmpBatch = user["batch"] as? PFObject
                
                self.gender = user["gender"] as? String
                self.interested = user["interested"] as? String
                
                if tmpBatch == nil {
                    callback?()
                } else {
                    tmpBatch?.fetchIfNeededInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
                        if let batch = object {
                            self.batch = Batch(batch)
                        } else {
                            ErrorHandler.handleParseError(error!)
                        }
                        
                        callback?()
                    })
                }
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
        //query.whereKey("gender", equalTo: self.interested)
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