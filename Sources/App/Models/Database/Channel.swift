//
//  Channel.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Foundation
import Vapor
import FluentPostgreSQL

final class Channel: Codable {
    
    var id: Channel.ID?
    
    init(id: String) {
        
        self.id = id
    }
}

extension Channel: Model {
    
    typealias ID = String
    typealias Database = PostgreSQLDatabase
    
    static var idKey: IDKey {
        return \.id
    }
}

extension Channel: Migration { }

extension Channel: Content { }

extension Channel: Parameter {
    
    static func make(
        for parameter: String,
        using container: Container
        ) throws -> Channel {
        
        return Channel(id: parameter)
    }
}
