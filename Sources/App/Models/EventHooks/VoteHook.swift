//
//  VoteHook.swift
//  App
//
//  Created by Chris Martin on 4/29/18.
//

import Foundation
import Vapor
import Fluent

struct VoteHook: EventHook {
    
    let event: Event
    
    init(event: Event) {
        
        self.event = event
    }
    
    func handleEvent(on worker: Container) throws -> Future<Event> {
        
        let attributes = try parse(using: event.text)
        
        return worker.withPooledConnection(to: .psql) { conn in
            
            let upvote = try self.event.user.get(on: conn)
                .flatMap(to: Upvote.self) {
                    
                    try Upvote.create(
                        by: $0,
                        amount: attributes.amount,
                        target: attributes.target,
                        on: conn
                    )
                }
            
            let targetUser = try User.fetch(with: attributes.target, on: conn)
            let messageResponse = try self.sendResponse(onCompletionOf: targetUser, and: upvote, on: worker)
            
            return messageResponse.transform(to: self.event)
                .always { try? worker.releasePooledConnection(conn, to: .psql) }
        }
            
        .catchFlatMap { error in
            
            if error as? Upvote.Error == Upvote.Error.equalSourceAndTarget {
                return try self.sendInsult(to: self.event.userID, on: worker)
                    .transform(to: self.event)
            }
            
            throw error
        }
    }
    
    private func sendResponse(onCompletionOf user: Future<User>, and upvote: Future<Upvote>, on worker: Container) throws -> Future<Response> {
        
        return flatMap(to: Response.self, upvote, user) { _, user in
            
            let upvoteService = try worker.make(UpvoteService.self)
            return try upvoteService.countUpvotes(for: user, on: worker)
                .flatMap(to: Response.self) {
                    try SlackMessage(
                        text: "\(user.realName): \($0)",
                        channelID: self.event.channelID
                    ).send(on: worker)
                }
        }
    }
    
    private func sendInsult(to userID: User.ID, on worker: Container) throws -> Future<Response> {
        
        return worker.withPooledConnection(to: .psql) { conn -> Future<Response> in
            try User.fetch(with: userID, on: conn)
                .map(to: String.self) { user in
                    let generator = try worker.make(InsultGenerator.self)
                    return try generator.generateInsult(for: user)
                }
                .flatMap(to: Response.self) { insult in
                    try SlackMessage(text: insult, channelID: self.event.channelID)
                        .send(on: worker)
                }
                .always { try? worker.releasePooledConnection(conn, to: .psql) }
        }
    }
}

// MARK: - Parsing
extension VoteHook {
    
    typealias UpvoteAttributes = (target: User.ID, amount: Int)
    
    private func parse(using text: String) throws -> UpvoteAttributes {
        
        let components = text.split(separator: " ")
        
        guard components.count == 2 else {
            throw Error.invalidNumberOfComponents
        }
        
        guard let amountComponent = components.first.flatMap(String.init) else {
            throw Error.missingAmount
        }
        
        guard let tag = components.last.flatMap(String.init),
            let userTag = UserTag(tag: tag) else {
            throw Error.missingTarget
        }
        
        let amount = try parseAmount(from: amountComponent)
        
        return UpvoteAttributes(target: userTag.userID, amount: amount)
    }
    
    private func parseAmount(from text: String) throws -> Int {
        
        guard let value = Int(text), abs(value) == 1 else {
            throw Error.badAmount
        }
        
        return value
    }
}

// MARK: - Errors
extension VoteHook {
    
    enum Error: Swift.Error {
        
        case invalidNumberOfComponents
        case missingAmount
        case missingTarget
        case badAmount
    }
}
