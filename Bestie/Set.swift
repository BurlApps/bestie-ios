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
        
        var looser = self.image1
        
        if winner.parse.objectId == self.image1.parse.objectId {
            looser = self.image2
        }
        
        PFCloud.callFunctionInBackground("setVoted", withParameters: [
            "winner": winner.parse.objectId!,
            "loser": looser.parse.objectId!
        ]) { (response: AnyObject?, error: NSError?) -> Void in
            if response != nil {
                let data = response as! NSDictionary
                
                user.batch?.userVotes = data["userVotes"] as! Float
                
                Globals.progressBarsUpdate()
                
                if data["finished"] as! Bool {
                    Globals.showVoterAlert()
                }
            } else if error != nil {
                ErrorHandler.handleParseError(error!)
            }
        }
        
        user.mixpanel.people.increment("Votes", by: 1)
    }
}
