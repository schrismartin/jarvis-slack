//
//  Array+Convenience.swift
//  App
//
//  Created by Chris Martin on 4/15/18.
//

import Foundation

extension Array {
    
    @discardableResult
    mutating func popFirst() -> Element? {
        
        guard count > 0 else { return nil }
        return remove(at: 0)
    }
}

extension Array where Element: Numeric {
    
    func summed() -> Element {
        
        return reduce(0, +)
    }
    
    func averaged() throws -> Double {
        
        guard !isEmpty else {
            throw AverageError.zeroElements
        }
        
        switch summed() {
        case let value as Double:
            return Double(value) / Double(count)
        case let value as Int:
            return Double(value) / Double(count)
        default:
            throw AverageError.elementNotConvertableToDouble
        }
    }
    
    enum AverageError: Error {
        case zeroElements
        case elementNotConvertableToDouble
    }
}
