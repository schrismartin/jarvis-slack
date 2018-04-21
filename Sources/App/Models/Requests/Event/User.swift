//
//  User.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Foundation
import Vapor

final class User: Codable {
    
    var id: String
    
    init(id: String) {
        
        self.id = id
    }
}

extension User: Content { }

extension User: Parameter {
    
    static func make(
        for parameter: String,
        using container: Container
    ) throws -> User {
        
        return User(id: parameter)
    }
}
