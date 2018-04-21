//
//  ComplimentGenerator.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Foundation
import Vapor
import Random

class ComplimentGenerator: Service {
    
    func generateCompliment() throws -> String {
        
        let numberOfCompliments = UInt32(ComplimentGenerator.compliments.count)
        
        let index = try OSRandom().generate(UInt32.self)
            % numberOfCompliments
        
        return ComplimentGenerator.compliments[Int(index)]
    }
}
