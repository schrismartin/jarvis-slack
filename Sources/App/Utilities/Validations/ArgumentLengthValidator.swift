//
//  ArgumentLengthValidator.swift
//  App
//
//  Created by Chris Martin on 4/21/18.
//

import Validation
import Vapor

extension Validator where T == String {
    
    /// Validates whether a `String` is a valid Slack token.
    ///
    ///     try validations.add(\.token, ["token"], .slackToken)
    ///
    
    static func argumentLength(satisfies length: CommandLength) -> Validator<T> {
        return ArgumentLengthValidator(length: length).validator()
    }
}

// MARK: Private

/// Validates whether a string has a certain number of words.
fileprivate struct ArgumentLengthValidator: ValidatorType {
    
    /// See `ValidatorType`.
    public var validatorReadable: String {
        return "a valid number of arguments"
    }
    
    private var length: CommandLength
    
    /// Creates a new `ArgumentLengthValidator`.
    public init(length: CommandLength) {
        
        self.length = length
    }
    
    /// See `Validator`.
    public func validate(_ text: String) throws {
        
        let parser = try CommandParser(text: text)
        guard parser.satisfies(length) else {
            throw UserCommandError.invalidNumberOfArguments(expected: length)
        }
    }
}
