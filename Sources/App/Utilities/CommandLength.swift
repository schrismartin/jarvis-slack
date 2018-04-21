//
//  CommandLength.swift
//  App
//
//  Created by Chris Martin on 4/21/18.
//

import Foundation

enum CommandLength {
    
    case unbounded
    case zero
    case equals(Int)
    case atLeast(Int)
    case range(CountableClosedRange<Int>)
}

extension CommandLength: CustomStringConvertible {
    
    func isSatisfied(by parser: CommandParser) -> Bool {
        
        let numberOfArguments = parser.numberOfArguments
        
        switch self {
        case .unbounded:
            return true
        case .zero:
            return numberOfArguments == 0
        case .equals(let length):
            return numberOfArguments == length
        case .atLeast(let minLength):
            return numberOfArguments >= minLength
        case .range(let range):
            return range.contains(numberOfArguments)
        }
    }
    
    var description: String {
        
        switch self {
        case .unbounded:
            return "none"
        case .zero:
            return "num_args == 0"
        case .equals(let length):
            return "num_args == \(length)"
        case .atLeast(let minLength):
            return "num_args >= \(minLength)"
        case .range(let range):
            return "num_args between \(range.lowerBound) and \(range.upperBound)"
        }
    }
}
