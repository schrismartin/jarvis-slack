//
//  Upvote+Migrations.swift
//  App
//
//  Created by Chris Martin on 9/30/18.
//

import Foundation
import Vapor
import FluentPostgreSQL

extension Upvote {
    
    struct AddTimestamp: Migration {
        
        typealias Database = PostgreSQLDatabase
        
        static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
            
            return PostgreSQLDatabase.update(Upvote.self, on: conn) { builder in
                builder.field(for: \.timestamp)
            }
        }
        
        static func revert(on conn: PostgreSQLConnection) -> Future<Void> {
            
            return PostgreSQLDatabase.update(Upvote.self, on: conn) { builder in
                builder.deleteField(for: \.timestamp)
            }
        }
    }
}
