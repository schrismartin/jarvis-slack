//
//  Event.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Foundation
import FluentPostgreSQL
import Vapor

enum EventType: String, Codable, ReflectionDecodable, PostgreSQLColumnStaticRepresentable {
    
    case message
    case other
    
    static func reflectDecoded() throws -> (EventType, EventType) {
        return (.message, .other)
    }
    
    static var postgreSQLColumn: PostgreSQLColumn {
        
        return PostgreSQLColumn(type: .text)
    }
}

final class Event: Codable {
    
    var id: Int?
    var type: String
    var userID: User.ID
    var channel: String
    var text: String
    var timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case type
        case userID = "user"
        case channel
        case text
        case timestamp = "ts"
    }
    
    init(id: Int?, type: String, userID: User.ID, channel: String, text: String, timestamp: Date) {
        
        self.id = id
        self.type = type
        self.userID = userID
        self.text = text
        self.timestamp = timestamp
        self.channel = channel
    }
    
    var user: Parent<Event, User> {
        
        return parent(\.userID)
    }
}

extension Event: PostgreSQLModel { }

extension Event: Migration { }

extension Event: Content { }

extension Event: CustomStringConvertible {
    
    var description: String {
        
        return """
        type: \(type), \
        user: \(user), \
        channel: \(channel), \
        text: \(text), \
        timestamp: \(timestamp)
        """
    }
}
