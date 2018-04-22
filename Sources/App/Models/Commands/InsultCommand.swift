//
//  InsultCommand.swift
//  App
//
//  Created by Chris Martin on 4/21/18.
//

import Foundation
import Vapor

struct InsultCommand: BasicUserCommand {
    
    static var keyword: String {
        return "insult"
    }
    
    static var commandLength: CommandLength {
        return .range(0...1)
    }
    
    var target: String?
    
    init(contents: String?, request: UserCommandRequest) {
        
        target = contents
    }
    
    func generateResponse(using container: Container) throws -> UserCommandResponse {
        
        let generator = try container.make(InsultGenerator.self)
        return UserCommandResponse(
            text: try createInsult(using: generator),
            replyType: .inChannel
        )
    }
    
    func createInsult(using generator: InsultGenerator) throws -> String {
        
        let insult = try generator.generateInsult()
        if let target = target {
            return "\(target), \(insult.lowercased())"
        }
        else {
            return insult
        }
    }
}
