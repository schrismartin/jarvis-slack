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
    
    var response: Reply {
        
        return Reply(
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
    
    static func optionalUnwrappingError(file: StaticString = #file, line: UInt = #line, function: String = #function) -> UserCommandError {
        
        return UserCommandError.internalError(reason: """
            Optional Unwrapping Error –––
            \(file): \(line)
            Function: \(function)
            
            Report to Chris. Be sure to tell him he fucked up.
            """
        )
    }
    
    static var invalidBurnUsage: UserCommandError {
        
        return UserCommandError(message: "You should probably try tagging someone, dumbass.")
    }
    
    static var invalidComplimentUsage: UserCommandError {
        
        return UserCommandError(message: "Try tagging them instead!")
    }
}
