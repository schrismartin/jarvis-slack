//
//  PostgreSQLDatabaseConfig+Init.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Foundation
import PostgreSQL

extension PostgreSQLDatabaseConfig {
    
    /// Creates a `PostgreSQLDatabaseConfig` frome a connection string.
    public init(from url: URL) throws {
        
        guard
            let username = url.user,
            let hostname = url.host,
            url.scheme == "postgres"
        else {
            
            throw PostgreSQLError(
                identifier: "Bad Connection String",
                reason: "Config could not be parsed",
                possibleCauses: ["Foundation URL is unable to parse the provided connection string"],
                suggestedFixes: ["Check the connection string being passed"],
                source: .capture()
            )
        }
        
        self.init(
            hostname: hostname,
            port: url.port ?? 5432,
            username: username,
            database: String(url.path.dropFirst()),
            password: url.password
        )
    }
}
