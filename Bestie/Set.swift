//
//  Set.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/29/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

class VoterSet {
    
    var image1: Image!
    var image2: Image!
    var fake = false
    
    convenience init(_ image1: Image, _ image2: Image) {
        self.init()
        
        self.image1 = image1
        self.image2 = image2
    }
    
    func voted(winner: Image) {
        let user = User.current()
        
        if(fake) {
            return
        }
        
        if let batch = user.batch {
            batch.userVoted()
        }
        
        var looser = self.image1
        
        if winner.parse.objectId == self.image1.parse.objectId {
            looser = self.image2
        }
        
        PFCloud.callFunctionInBackground("setVoted", withParameters: [
            "winner": winner.parse.objectId!,
            "loser": looser.parse.objectId!
        ])
        
        user.mixpanel.people.increment("Votes", by: 1)
    }
}
