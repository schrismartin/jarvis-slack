//
//  UserCommandError.swift
//  App
//
//  Created by Chris Martin on 4/19/18.
//

import Foundation
import Vapor

struct UserCommandError: Error {
    
    // MARK: - Properties
    
    let message: String
    
    // MARK: - Computed Properties
    
    var response: UserCommandResponse {
        
        return UserCommandResponse(
            text: message,
            replyType: .ephemeral
        )
    }
    
    // MARK: - Initializers
    
    private init(message: String) {
        
        self.message = message
    }
}

// MARK: - Errors
extension UserCommandError {
    
    static var invalidNumberOfArguments: UserCommandError {
        
        return UserCommandError(message: "Not enuough arguments")
    }
    
    static func invalidNumberOfArguments(expected: CommandLength) -> UserCommandError {
        
        return UserCommandError(message: "Invalid number of arguments. Expected: \(expected.description)")
    }
    
    static var unsupportedOperation: UserCommandError {
        
        return UserCommandError(message: "This operation is not supported.")
    }
    
    static func unrecognizedCommand(_ command: String) -> UserCommandError {
        
        return UserCommandError(message: "Unrecognized comand: \(command)")
    }
    
    static func internalError(reason: String) -> UserCommandError {
        
        return UserCommandError(message: "Something went wrong, reason: \(reason)")
    }
}
