//
//  LoggedEvent.swift
//  App
//
//  Created by Chris Martin on 4/29/18.
//

import Foundation
import FluentPostgreSQL
import Vapor

final class Event: Codable {
    
    var id: Event.ID?
    var type: String
    var userID: User.ID
    var channelID: Channel.ID
    var text: String
    var timestamp: Date
    
    init(id: Event.ID?, type: String, userID: User.ID, channel: Channel.ID, text: String, timestamp: Date) {
        
        self.id = id
        self.type = type
        self.userID = userID
        self.text = text
        self.timestamp = timestamp
        self.channelID = channel
    }
    
    var user: Parent<Event, User> {
        
        return parent(\.userID)
    }
    
    var channel: Parent<Event, Channel> {
        
        return parent(\.channelID)
    }
}

extension Event {
    
    convenience init(from request: SlackEventRequest) {
        
        self.init(
            id: request.eventID,
            type: request.event.type,
            userID: request.event.userID,
            channel: request.event.channelID,
            text: request.event.text,
            timestamp: request.event.timestamp
        )
    }
}

extension Event: Model {
    
    typealias ID = String
    typealias Database = PostgreSQLDatabase
    
    static var idKey: IDKey {
        return \.id
    }
}

extension Event: Migration { }

extension Event: Content { }

extension Event: CustomStringConvertible {
    
    var description: String {
        
        return """
        id: \(id), \
        type: \(type), \
        user: \(userID), \
        channel: \(channelID), \
        text: \(text), \
        timestamp: \(timestamp)
        """
    }
}
