//
//  Batch.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/27/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

class Batch {
    
    // MARK: Instance Variables
    var active: Bool!
    var votes: Float!
    var maxVotes: Float!
    var userVotes: Float!
    var images: [Image] = []
    var parse: PFObject!
    
    // MARK: Convenience Methods
    convenience init(_ object: PFObject) {
        self.init()
        
        self.active = object["active"] as? Bool
        self.votes = object["votes"] as? Float
        self.userVotes = object["userVotes"] as? Float
        self.maxVotes = object["maxVotes"] as? Float
        self.parse = object
    }
    
    class func create(images: [Image], user: User, callback: ((batch: Batch) -> Void)!) {
        let batch = PFObject(className: "Batch")
        let relation = batch.relationForKey("images")
        var maxVotes = 0
        
        for image in images {
            maxVotes += image.maxVotes
            relation.addObject(image.parse)
        }
        
        batch["active"] = true
        batch["maxVotes"] = maxVotes
        batch["creator"] = user.parse
        
        batch.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                let newBatch = Batch(batch)
                
                for image in images {
                    image.activate(newBatch)
                }
                
                user.addBatch(newBatch, callback: { () -> Void in
                    callback?(batch: newBatch)
                })
            } else {
                ErrorHandler.handleParseError(error!)
            }
        }
        
        user.mixpanel.people.increment("Batches", by: 1)
    }
    
    func userVoted() {
        let userVotes = self.userVotes + 1
        
        if userVotes == self.maxVotes {
            Globals.showVoterAlert()
        }
        
        if userVotes <= self.maxVotes {
            self.userVotes = userVotes
            Globals.batchUpdated()
        }
    }
    
    func userPercent() -> Float {
        return self.userVotes/self.maxVotes
    }
    
    func votesPercent() -> Float {
        return self.votes/self.maxVotes
    }
    
    func percent() -> Float {
        return self.votesPercent() * self.userPercent()
    }
    
    func fetch(callback: (() -> Void)!) {
        if !self.parse.isDataAvailable() {
            callback?()
            return
        }
        
        self.parse.fetchInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            if let data: PFObject = object {
                self.active = data["active"] as? Bool
                self.votes = data["votes"] as? Float
                self.userVotes = data["userVotes"] as? Float
                self.maxVotes = data["maxVotes"] as? Float
                callback?()
            } else {
                callback?()
                ErrorHandler.handleParseError(error!)
            }
        }
    }
    
    func getImages(callback: ((images: [Image]) -> Void)!) {
        let relation = self.parse.relationForKey("images")
        let query = relation.query()
        
        query!.addDescendingOrder("score")
        
        query!.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil && objects != nil {
                self.images.removeAll()
                
                for object in objects! {
                    self.images.append(Image(object))
                }
                
                callback(images: self.images)
            } else {
                ErrorHandler.handleParseError(error!)
            }
        })
    }

}
