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
    var votes: Int!
    var maxVotes: Int!
    var images: [Image]!
    var parse: PFObject!
    
    // MARK: Convenience Methods
    convenience init(_ object: PFObject) {
        self.init()
        
        self.active = object["active"] as? Bool
        self.votes = object["votes"] as? Int
        self.maxVotes = object["maxVotes"] as? Int
        self.parse = object
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
