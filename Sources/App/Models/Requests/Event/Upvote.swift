//
//  Upvote.swift
//  App
//
//  Created by Chris Martin on 4/29/18.
//

import Foundation
import Vapor
import FluentPostgreSQL

final class Upvote: Codable {
    
    var id: Upvote.ID?
    var sender: User.ID
    var target: User.ID
    var count: Int
    
    init(sender: User.ID, target: User.ID, count: Int = 0) throws {
        
        guard sender != target else {
            throw Error.equalSourceAndTarget
        }
        
        self.sender = sender
        self.target = target
        self.count = count
    }
    
    var targetUser: Parent<Upvote, User> {
        
        return parent(\.target)
    }
    
    var sendingUser: Parent<Upvote, User> {
        
        return parent(\.sender)
    }
}

extension Upvote {
    
    func incrementingCount(by amount: Int) -> Upvote {
        
        count += amount
        return self
    }
}

extension Upvote {
    
    static func create(by user: User, amount: Int, target: User.ID, on conn: DatabaseConnectable) throws -> Future<Upvote> {
        
        return try user.sentUpvotes.query(on: conn)
            .filter(\Upvote.target == target)
            .first()
            .map(to: Upvote.self) { vote in
                
                let userID = try user.requireID()
                return try vote ?? Upvote(sender: userID, target: target)
            }
            .do { $0.count += amount }
            .save(on: conn)
    }
}

extension Upvote: PostgreSQLModel { }
extension Upvote: Migration { }

extension Upvote {
    
    enum Error: Swift.Error {
        
        case equalSourceAndTarget
    }
}
