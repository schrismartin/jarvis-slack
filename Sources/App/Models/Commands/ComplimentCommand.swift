//
//  ComplimentCommand.swift
//  App
//
//  Created by Chris Martin on 4/21/18.
//

import Foundation
import Vapor

struct ComplimentCommand: BasicUserCommand {
    
    static var keyword: String {
        return "compliment"
    }
    
    static var commandLength: CommandLength {
        return .range(0...1)
    }
    
    var target: String?

    init(contents: String?, request: UserCommandRequest) {
    
        target = contents
    }
    
    func generateResponse(using container: Container) throws -> UserCommandResponse {
        
        let generator = try container.make(ComplimentGenerator.self)
        return UserCommandResponse(
            text: try createCompliment(using: generator),
            replyType: .inChannel
        )
    }
    
    func createCompliment(using generator: ComplimentGenerator) throws -> String {
        
        let compliment = try generator.generateCompliment()
        if let target = target {
            return "\(target), \(compliment.lowercased())"
        }
        else {
            return compliment
        }
    }
}
