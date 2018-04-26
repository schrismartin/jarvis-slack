//
//  Event.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Foundation
import Vapor

enum EventType: String, Codable {
    case message
}

final class Event: Codable {
    
    var type: EventType
    var user: String
    var channel: String
    var text: String
    var timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        
        case type
        case user
        case channel
        case text
        case timestamp = "ts"
    }
    
    init(type: EventType, user: String, channel: String, text: String, timestamp: Date) {
        
        self.type = type
        self.user = user
        self.text = text
        self.timestamp = timestamp
        self.channel = channel
    }
}

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
