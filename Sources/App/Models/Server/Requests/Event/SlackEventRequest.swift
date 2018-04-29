//
//  SlackResponse.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Foundation
import Vapor
import Validation

struct SlackEventRequest: SlackRequest {
    
    var token: String
    var event: SlackEvent
    var eventID: String
    
    enum CodingKeys: String, CodingKey {
        
        case token
        case event
        case eventID = "event_id"
    }
}

struct SlackEvent: Codable {
    
    var type: String
    var userID: User.ID
    var channelID: String
    var text: String
    var timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        
        case type
        case userID = "user"
        case channelID = "channel"
        case text
        case timestamp = "ts"
    }
}
