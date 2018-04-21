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
    static let commandLength = CommandLength.atLeast(1)
    
    var contents: String
    
    init(contents: String?, request: UserCommandRequest) throws {
        
        self.contents = try contents.unwrapped()
    }
    
    func generateResponse(using container: Container) throws -> UserCommandResponse {
        
        return UserCommandResponse(
            text: "Echo: \(self.contents)",
            replyType: .inChannel
        )
    }
}
