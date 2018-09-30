//
//  SentimentCommand.swift
//  App
//
//  Created by Chris Martin on 5/6/18.
//

import Foundation
import Vapor

struct SentimentCommand: UserCommand {
    
    typealias SentimentData = (positivity: Double, objectivity: Double, count: Int)
    
    static var keyword: String {
        return "sentiment"
    }
    
    static var description: String {
        return "Gets the sentiment scores of the specified user (or yourself if none is specified)"
    }
    
    static var isHidden: Bool {
        return true
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
        
        return container.withPooledConnection(to: .psql) { connection in
            try User.fetch(with: self.targetUser, on: connection)
                .always { try? container.releasePooledConnection(connection, to: .psql) }
            }
            .flatMap(to: String.self) { user in
                
                try Sentiment.allSentiments(for: user, on: container)
                    .map(to: String.self) {
                        
                        let polarity = String($0.polarity, numberOfDigits: 3)
                        let objectivity = String($0.objectivity, numberOfDigits: 3)
                        let pConfidence = String($0.polarityDifferential, numberOfDigits: 3)
                        let oConfidence = String($0.objectivityDifferential, numberOfDigits: 3)
                        
                        return """
                        Sentiment stats for _\(user.realName)_
                        • *Positivity*: \(polarity) ±\(pConfidence)
                        • *Objectivity*: \(objectivity) ±\(oConfidence)
                        • *Data Size*: \($0.count) messages
                        
                        _*All stats are on a scale of -1 to 1._
                        """
                }
            }
            .map { Reply(text: $0, replyType: .inChannel) }
    }
}
