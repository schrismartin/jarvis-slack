//
//  SentimentCommand.swift
//  App
//
//  Created by Chris Martin on 5/6/18.
//

import Foundation
import Vapor

struct SentimentCommand: UserCommand {
    
    typealias SentimentData = (positivity: Double, objectivity: Double)
    
    static var keyword: String {
        return "sentiment"
    }
    
    static var description: String {
        return "Gets the sentiment scores of the specified user (or yourself if none is specified)"
    }
    
    static var commandLength: CommandLength {
        return .range(0...1)
    }
    
    var targetUser: User.ID
    
    init(contents: String?, request: UserCommandRequest) throws {
        
        if let contents = contents, let tag = UserTag(tag: contents) {
            self.targetUser = tag.userID
        }
        else {
            self.targetUser = request.userID
        }
    }
    
    func reply(using container: Container) throws -> Future<Reply> {
        
        return container.withPooledConnection(to: .psql) { try User.fetch(with: self.targetUser, on: $0) }
            .flatMap(to: String.self) { user in
                let positivity = try Sentiment.averagePositivity(for: user, on: container)
                let objectivity = try Sentiment.averageObjectivity(for: user, on: container)
                return map(to: SentimentData.self, positivity, objectivity) { pos, obj in
                    SentimentData(positivity: pos, objectivity: obj)
                }
                .map { "\(user.name) – positivity: \($0.positivity), objectivity: \($0.objectivity)" }
            }
            .map { Reply(text: $0, replyType: .inChannel) }
    }
}
