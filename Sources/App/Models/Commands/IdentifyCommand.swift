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
        
        return container.withPooledConnection(to: .psql) { connection -> Future<User?> in
            return User.query(on: connection)
                .filter(\User.id == self.sender)
                .first()
        }
        .map(to: Reply.self) {
            let tag = UserTag(
                userID: try $0.unwrapped().requireID(),
                username: try $0.unwrapped().name
            )
            
            return Reply(
                text: """
                Your name is *\(try $0.unwrapped().realName)*, \
                your username is \(tag.tagValue), \
                and your user-id is `\(try $0.unwrapped().id.unwrapped())`
                """,
                replyType: .ephemeral
            )
        }
    }
}
