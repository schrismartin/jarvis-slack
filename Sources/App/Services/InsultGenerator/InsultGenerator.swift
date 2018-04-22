//
//  InsultGenerator.swift
//  App
//
//  Created by Chris Martin on 4/21/18.
//

import Foundation
import Vapor
import Random

class InsultGenerator: Service {
    
    func generateInsult() throws -> String {
        
        let numberOfInsults = UInt32(InsultGenerator.insults.count)
        
        let index = try OSRandom().generate(UInt32.self)
            % numberOfInsults
        
        return InsultGenerator.insults[Int(index)]
    }
}
