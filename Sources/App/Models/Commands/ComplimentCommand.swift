//
//  ComplimentCommand.swift
//  App
//
//  Created by Chris Martin on 4/21/18.
//

import Foundation
import Vapor
import Fluent

struct ComplimentCommand: UserCommand {
    
    static var keyword: String {
        return "compliment"
    }
    
    static var description: String {
        return "Create a compliment for yourself, or direct it at the specified user."
    }
    
    static var commandLength: CommandLength {
        return .range(0...1)
    }
    
    let target: UserTag

    init(contents: String?, request: UserCommandRequest) throws {
    
        guard let target = contents.flatMap(UserTag.init) else {
            throw UserCommandError.invalidComplimentUsage
        }
        
        self.target = target
    }
    
    func reply(using container: Container) throws -> Future<Reply> {
        
        let generator = try container.make(ComplimentGenerator.self)
        
        return container.withPooledConnection(to: .psql) { connection in
            User.query(on: connection)
                .filter(\User.id == self.target.userID)
                .first()
        }
        .unwrap(or: UserCommandError.optionalUnwrappingError())
        .map(to: Reply.self) {
            Reply(
                text: try self.createCompliment(using: generator, for: $0),
                replyType: .inChannel
            )
        }
    }
    
    func createCompliment(using generator: ComplimentGenerator, for user: User) throws -> String {
        
        let compliment = try generator.generateCompliment()
        let name = try user.firstName.unwrapped()
        return "\(name), \(compliment.lowercased())"
    }
}
