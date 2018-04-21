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
        
        let index = try OSRandom().generate(Int.self)
            % ComplimentGenerator.compliments.count
        
        return ComplimentGenerator.compliments[index]
    }
}
