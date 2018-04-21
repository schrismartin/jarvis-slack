//
//  EchoCommand.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Foundation
import Vapor

struct EchoCommand: BasicUserCommand {
    
    static let keyword: String = "echo"
    
    var contents: String
    
    func generateResponse() throws -> UserCommandResponse {
        
        return UserCommandResponse(
            text: "Echo: \(self.contents)",
            replyType: .inChannel
        )
    }
}
