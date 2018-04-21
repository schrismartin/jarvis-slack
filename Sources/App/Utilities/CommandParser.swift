//
//  CommandParser.swift
//  App
//
//  Created by Chris Martin on 4/19/18.
//

import Vapor

class CommandParser {
    
    private var components: [Substring]
    
    var command: String {
        
        return String(components.first ?? "")
    }
    
    var body: String {
        
        let range = 1 ..< components.count
        return components[range]
            .joined(separator: " ")
    }
    
    init(text: String) throws {
        
        components = text.split(separator: " ")
        
        guard !components.isEmpty else {
            throw UserCommandError(message: "Not enuough arguments")
        }
    }
}
