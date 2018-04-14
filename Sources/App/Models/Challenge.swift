//
//  Challenge.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Foundation
import Vapor
import Validation

struct Challenge: Codable {
    
    var token: String
    var challenge: String
    var type: String
}

// MARK: - Validatable
extension Challenge: Validatable {
    
    static func validations() throws -> Validations<Challenge> {
        
        var validations = Validations(Challenge.self)
        validations.add(\.token, at: ["token"], .slackToken)
        
        return validations
    }
}

extension Challenge: Content {}
