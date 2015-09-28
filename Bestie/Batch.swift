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
    var images: [Image]!
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
    
    func imageVoted() {
        self.votes = self.votes + 1
        self.parse.incrementKey("votes")
        self.parse.saveInBackground()
    }
    
    func userVoted() {
        self.userVotes = self.userVotes + 1
        self.parse.incrementKey("userVotes")
        self.parse.saveInBackground()
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
    
    func getImages(callback: ((images: [Image]) -> Void)!) {
        let relation = self.parse.relationForKey("images")
        
        relation.query()?.findObjectsInBackgroundWithBlock({ (objects: [PFObject]?, error: NSError?) -> Void in
            if error != nil && objects != nil {
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
