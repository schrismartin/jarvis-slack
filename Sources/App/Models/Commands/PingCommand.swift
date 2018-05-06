//
//  PingCommand.swift
//  App
//
//  Created by Chris Martin on 5/6/18.
//

import Foundation
import Vapor

struct PingCommand: UserCommand {
    
    static var keyword: String {
        return "ping"
    }
    
    static var description: String {
        return "Pings the server to ensure it's active."
    }
    
    static var commandLength: CommandLength {
        return .zero
    }
    
    init(contents: String?, request: UserCommandRequest) throws { }
    
    func reply(using container: Container) throws -> Future<Reply> {
        
        return Reply(text: "Server is active.", replyType: .ephemeral)
            .future(on: container)
    }
}
