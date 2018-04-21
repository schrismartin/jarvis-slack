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
