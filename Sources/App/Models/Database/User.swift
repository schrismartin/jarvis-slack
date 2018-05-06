//
//  User.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Foundation
import FluentPostgreSQL
import Vapor

final class User: Codable {
    
    var id: String?
    var name: String
    var realName: String
    var isBot: Bool
    var isAppUser: Bool
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case name
        case realName = "real_name"
        case isBot = "is_bot"
        case isAppUser = "is_app_user"
    }
    
    init(id: String, name: String, realName: String, isBot: Bool, isAppUser: Bool) {
        
        self.id = id
        self.name = name
        self.realName = realName
        self.isBot = isBot
        self.isAppUser = isAppUser
    }
}

extension User {
    
    var firstName: String? {
        
        return realName
            .split(separator: " ")
            .first
            .flatMap(String.init)
    }
    
    var lastName: String? {
        
        return realName
            .split(separator: " ")
            .last
            .flatMap(String.init)
    }
}

// MARK: - Slack Entities
extension User {
    
    var events: Children<User, Event> {
        
        return children(\.userID)
    }
    
    var commands: Children<User, UserCommandRequest> {
        
        return children(\.userID)
    }
}

// MARK: - Upvotes
extension User {
    
    var upvotes: Children<User, Upvote> {
        
        return children(\.target)
    }
    
    var sentUpvotes: Children<User, Upvote> {
        
        return children(\.sender)
    }
}

// MARK: - Model
extension User: Model {

    typealias Database = PostgreSQLDatabase
    typealias ID = String
    
    static var idKey: IDKey {
        return \.id
    }
}

extension User {
    
    static func fetch(with id: User.ID, on conn: PostgreSQLConnection) throws -> Future<User> {
        
        return try conn.query(User.self)
            .filter(\User.id == id)
            .first()
            .unwrap(or: UserCommandError.optionalUnwrappingError())
    }
}

extension User: Migration { }

extension User: Content { }

extension User: Parameter { }
