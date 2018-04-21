//
//  ArgumentLengthValidatable.swift
//  App
//
//  Created by Chris Martin on 4/21/18.
//

import Foundation
import Validation

protocol ArgumentLengthValidatable: Validatable {
    
    static var commandLength: CommandLength { get }
    
    var content: String { get }
}

extension ArgumentLengthValidatable {
    
    static func validations() throws -> Validations<Self> {
        
        var validations = Validations(Self.self)
        validations.add(\.content, at: ["content"], .argumentLength(satisfies: Self.commandLength))
        
        return validations
    }
}
