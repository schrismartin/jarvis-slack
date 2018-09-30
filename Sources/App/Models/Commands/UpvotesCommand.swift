//
//  UpvotesCommand.swift
//  App
//
//  Created by Chris Martin on 4/30/18.
//

import Foundation
import Vapor
import Fluent

struct UpvotesCommand: UserCommand {
    
    let request: UserCommandRequest
    var targetUser: UserTag?
    
    static var keyword: String {
        return "upvotes"
    }
    
    static var description: String {
        return "Shows you the number of upvotes you currently have."
    }
    
    static var commandLength: CommandLength {
        return .range(0...1)
    }
    
    init(contents: String?, request: UserCommandRequest) throws {
        
        self.request = request
        
        if let contents = contents, let userTag = UserTag(tag: contents) {
            targetUser = userTag
        }
    }
    
    func reply(using container: Container) throws -> Future<Reply> {
        
        return container.withPooledConnection(to: .psql) { conn in
            
            let userID = self.targetUser?.userID ?? self.request.userID
            let user = try User.fetch(with: userID, on: conn)
    
            let upvoteCount = user.flatMap(to: Int.self) { user in
                let upvoteService = try container.make(UpvoteService.self)
                return try upvoteService.countUpvotes(for: user, on: container)
            }
            
            return map(to: Reply.self, user, upvoteCount) { (user, count) in
                Reply(text: "\(user.realName): \(count)")
            }
            .always { try? container.releasePooledConnection(conn, to: .psql) }
        }
    }
}
