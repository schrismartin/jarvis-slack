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
    
    init(sender: User.ID, target: User.ID, count: Int = 0) {
        
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

extension Upvote: PostgreSQLModel { }
extension Upvote: Migration { }
