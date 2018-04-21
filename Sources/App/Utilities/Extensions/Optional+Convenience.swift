//
//  Optional+Convenience.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Foundation
import Vapor

extension Optional {
    
    func unwrapped() throws -> Wrapped {
        
        guard case let .some(value) = self else {
            throw NSError(domain: "OptionalUnwrapping", code: -1)
        }
        
        return value
    }
}
