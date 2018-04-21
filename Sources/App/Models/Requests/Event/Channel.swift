//
//  Channel.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Foundation
import Vapor

final class Channel: Codable {
    
    var id: String
    
    init(id: String) {
        
        self.id = id
    }
}

extension Channel: Content { }

extension Channel: Parameter {
    
    static func make(
        for parameter: String,
        using container: Container
        ) throws -> Channel {
        
        return Channel(id: parameter)
    }
}
