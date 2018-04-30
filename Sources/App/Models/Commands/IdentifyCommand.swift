//
//  IdentifyCommand.swift
//  App
//
//  Created by Chris Martin on 4/29/18.
//

import Vapor
import FluentPostgreSQL

struct IdentifyCommand: UserCommand {
    
    var sender: User.ID
    
    static var keyword: String {
        return "identify"
    }
    
    static var description: String {
        return "Returns information on the sender"
    }
    
    static var commandLength: CommandLength {
        return .zero
    }
    
    init(contents: String?, request: UserCommandRequest) throws {
        
        self.sender = request.userID
    }
    
    func reply(using container: Container) throws -> Future<Reply> {
        
        return container.withNewConnection(to: .psql) { connection -> Future<User?> in
            return try connection.query(User.self)
                .filter(\User.id == self.sender)
                .first()
        }
        .map(to: Reply.self) {
            Reply(text: "Your name is \(try $0.unwrapped().realName), your username is \(try $0.unwrapped().name), and your id is \(try $0.unwrapped().id.unwrapped())", replyType: .ephemeral)
        }
    }
}
