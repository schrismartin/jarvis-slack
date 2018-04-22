//
//  Event.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Foundation
import Vapor

final class Event: Codable {
    
    var type: String
    var user: String?
    var text: String
    var timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        
        case type
        case user
        case text
        case timestamp = "ts"
    }
    
    init(type: String, user: String, text: String, timestamp: Date) {
        
        self.type = type
        self.user = user
        self.text = text
        self.timestamp = timestamp
    }
}

extension Event: Content { }
