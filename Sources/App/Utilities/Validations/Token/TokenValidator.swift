//
//  TokenValidator.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Validation
import Vapor

extension Validator where T == String {
    
    /// Validates whether a `String` is a valid Slack token.
    ///
    ///     try validations.add(\.token, ["token"], .slackToken)
    ///
    public static var slackToken: Validator<T> {
        return SlackTokenValidator().validator()
    }
}

// MARK: Private

/// Validates whether a string is a valid Slack token.
fileprivate struct SlackTokenValidator: ValidatorType {
    /// See `ValidatorType`.
    public var validatorReadable: String {
        return "a valid slack token"
    }
    
    /// Creates a new `SlackTokenValidator`.
    public init() {}
    
    /// See `Validator`.
    public func validate(_ token: String) throws {
        
        guard token == Environment.slackToken else {
            throw BasicValidationError.tokenMatchFailure
        }
    }
}
