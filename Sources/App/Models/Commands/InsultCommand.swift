//
//  InsultCommand.swift
//  App
//
//  Created by Chris Martin on 4/21/18.
//

import Foundation
import Vapor
import Fluent

struct InsultCommand: UserCommand {
    
    static var keyword: String {
        return "burn"
    }
    
    static var description: String {
        return "Insult yourself, or direct it at the specified user."
    }
    
    static var commandLength: CommandLength {
        return .range(0...1)
    }
    
    var target: UserTag
    
    init(contents: String?, request: UserCommandRequest) throws {
        
        guard let target = contents.flatMap(UserTag.init) else {
            throw UserCommandError.invalidBurnUsage
        }
        
        self.target = target
    }
    
    func reply(using container: Container) throws -> Future<Reply> {
        
        let generator = try container.make(InsultGenerator.self)
        
        return container.newConnection(to: .psql)
            .flatMap(to: User?.self) {
                try $0.query(User.self)
                    .filter(\User.id == self.target.userID)
                    .first()
            }
            .map(to: User.self) { try $0.unwrapped() }
            .map(to: Reply.self) {
                Reply(
                    text: try self.createInsult(using: generator, for: $0),
                    replyType: .inChannel
                )
            }
    }
    
    func createInsult(using generator: InsultGenerator, for user: User) throws -> String {
        
        let insult = try generator.generateInsult()
        let name = try user.firstName.unwrapped()
        return "\(name), \(insult.lowercased())"
    }
}
