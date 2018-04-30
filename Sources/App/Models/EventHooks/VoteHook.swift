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
    
    func handleEvent(on worker: Container) -> Future<Event> {
        
        do {
            let attributes = try parse(using: event.text)
            return worker.withNewConnection(to: .psql) { connection in
                try self.event.user.get(on: connection)
                    .flatMap(to: Upvote?.self) { user -> Future<Upvote?> in
                        try user.sentUpvotes.query(on: connection)
                            .filter(\Upvote.target == attributes.target)
                            .first()
                    }
                    .map(to: Upvote.self) {
                        $0 ?? Upvote(sender: self.event.userID, target: attributes.target)
                    }
                    .map(to: Upvote.self) { $0.incrementingCount(by: attributes.amount) }
                    .flatMap(to: Upvote.self) { $0.save(on: connection) }
            }
            .transform(to: event)
        }
        catch {
            print(error)
            return Future.map(on: worker) { self.event }
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
