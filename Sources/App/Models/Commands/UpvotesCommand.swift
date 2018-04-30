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
    
    static var keyword: String {
        return "upvotes"
    }
    
    static var description: String {
        return "Shows you the number of upvotes you currently have."
    }
    
    static var commandLength: CommandLength {
        return .zero
    }
    
    init(contents: String?, request: UserCommandRequest) throws {
        
        self.request = request
    }
    
    func reply(using container: Container) throws -> Future<Reply> {
        
        return container.withNewConnection(to: .psql) { connection in
            
            let user = try self.request.user.get(on: connection)
            
            /// TODO: Switch to this whenever possible.
            // let upvoteCount = user.flatMap(to: Int.self) { try $0.upvotes.query(on: connection)
            //    .aggregate(.sum, field: \Upvote.count) }
            
            let upvoteCount = user.flatMap(to: [Upvote].self) { try $0.upvotes.query(on: connection).all() }
                .map(to: Int.self) { $0.map { $0.count }.reduce(0, +) }
            
            return map(to: Reply.self, user, upvoteCount) { (user, count) in
                Reply(text: "\(user.realName): \(count)")
            }
        }
    }
}
