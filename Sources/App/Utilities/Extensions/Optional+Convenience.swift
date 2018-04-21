//
//  Optional+Convenience.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Foundation
import Vapor

extension Optional {
    
    func unwrapped(file: StaticString = #file, line: UInt = #line) throws -> Wrapped {
        
        guard case let .some(value) = self else {
            throw UserCommandError.internalError(reason: "Optional Unwrapping Error (file: \(file), line: \(line))")
        }
        
        return value
    }
}
