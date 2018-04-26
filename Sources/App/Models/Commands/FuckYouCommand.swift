//
//  FuckYouCommand.swift
//  App
//
//  Created by Chris Martin on 4/23/18.
//

import Foundation
import Vapor

struct FuckYouCommand: UserCommand {
    
    static var keyword: String {
        return "fuck"
    }
    
    static var description: String {
        return "Says fuck you"
    }
    
    static var commandLength: CommandLength {
        return .zero
    }
    
    init(contents: String?, request: UserCommandRequest) throws { }
    
    func reply(using container: Container) throws -> EventLoopFuture<Reply> {
        
        return Reply(text: "Fuck you", replyType: .ephemeral).future(on: container)
    }
}
