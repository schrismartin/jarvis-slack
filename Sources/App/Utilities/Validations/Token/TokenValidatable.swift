//
//  TokenValidatable.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Foundation
import Validation

protocol TokenValidatable: Validatable {
    
    var token: String { get set }
}

extension TokenValidatable {
    
    static func validations() throws -> Validations<Self> {
        
        var validations = Validations(Self.self)
        validations.add(\.token, at: ["token"], .slackToken)
        
        return validations
    }
}
