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
        
        return container.withNewConnection(to: .psql) { connection in
            
            let user = try self.fetchTargetUser(on: connection)
            
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
    
    private func fetchTargetUser(on connection: DatabaseConnectable) throws -> Future<User> {
        
        if let targetUser = targetUser {
            return connection.databaseConnection(to: .psql)
                .flatMap(to: User?.self) {
                    try $0.query(User.self).filter(\User.id == targetUser.userID).first()
                }
                .map(to: User.self) { try $0.unwrapped() }
        }
        else {
            return try request.user.get(on: connection)
        }
    }
}
