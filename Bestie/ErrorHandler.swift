//
//  ErrorHandler.swift
//  Bestie
//
//  Created by Brian Vallelunga on 9/27/15.
//  Copyright © 2015 Brian Vallelunga. All rights reserved.
//

class ErrorHandler {
    class func handleParseError(error: NSError) {
        if error.domain != PFParseErrorDomain {
            return
        }
        
        switch (error.code) {
            case PFErrorCode.ErrorInvalidSessionToken.rawValue:
                self.handleInvalidSessionTokenError()
            
            default: print(error)
        }
    }
        
    private class func handleInvalidSessionTokenError() {
        User.logout()
        Globals.showOnboarding()
        print("force logout")
    }
}
