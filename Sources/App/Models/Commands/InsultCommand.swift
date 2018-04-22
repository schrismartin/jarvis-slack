//
//  InsultCommand.swift
//  App
//
//  Created by Chris Martin on 4/21/18.
//

import Foundation
import Vapor

struct InsultCommand: UserCommand {
    
    static var keyword: String {
        return "insult"
    }
    
    static var description: String {
        return "Insult yourself, or direct it at the specified user."
    }
    
    static var commandLength: CommandLength {
        return .range(0...1)
    }
    
    var target: String?
    
    init(contents: String?, request: UserCommandRequest) {
        
        target = contents
    }
    
    func reply(using container: Container) throws -> Future<Reply> {
        
        let generator = try container.make(InsultGenerator.self)
        let response = Reply(
            text: try createInsult(using: generator),
            replyType: .inChannel
        )
        
        return response.future(on: container)
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
