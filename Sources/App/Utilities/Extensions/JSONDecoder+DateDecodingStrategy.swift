//
//  JSONDecoder+DateDecodingStrategy.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Foundation

extension JSONDecoder.DateDecodingStrategy {
    
    static var secondsSince1970String: JSONDecoder.DateDecodingStrategy {
        return .custom(decode1970DateString)
    }
    
    private static func decode1970DateString(from decoder: Decoder) throws -> Date {
        
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        let timeInterval = try TimeInterval(dateString).unwrapped()
        return Date(timeIntervalSince1970: timeInterval)
    }
}
