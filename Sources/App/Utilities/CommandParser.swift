//
//  CommandParser.swift
//  App
//
//  Created by Chris Martin on 4/19/18.
//

import Vapor

class CommandParser {
    
    // MARK: - Properties
    
    private var components: [Substring]
    
    // MARK: - Computed Properties
    
    var command: String {
        
        return String(components.first ?? "")
    }
    
    var body: String? {
        
        guard components.count > 1 else { return nil }
        
        let range = 1 ..< components.count
        return components[range]
            .joined(separator: " ")
    }
    
    var numberOfArguments: Int {
        
        return components.count - 1
    }
    
    // MARK: - Initializers
    
    init(text: String) throws {
        
        components = text.split(separator: " ")
        
        guard !components.isEmpty else {
            throw UserCommandError.invalidNumberOfArguments
        }
    }
    
    // MARK: - Actions
    
    func satisfies(_ length: CommandLength) -> Bool {
        
        return length.isSatisfied(by: self)
    }
}
