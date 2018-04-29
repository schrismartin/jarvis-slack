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
