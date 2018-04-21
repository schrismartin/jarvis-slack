//
//  UserCommandError.swift
//  App
//
//  Created by Chris Martin on 4/19/18.
//

import Foundation
import Vapor

struct UserCommandError: Error {
    
    var message: String
}

extension UserCommandError {
    
    var response: UserCommandResponse {
        
        return UserCommandResponse(
            text: message,
            replyType: .ephemeral
        )
    }
}
