//
//  String+Convenience.swift
//  App
//
//  Created by Chris Martin on 5/6/18.
//

import Foundation

extension String {
    
    init(_ double: Double, numberOfDigits: Int) {
        
        self.init(format: "%.\(numberOfDigits)lf", double)
    }
}
