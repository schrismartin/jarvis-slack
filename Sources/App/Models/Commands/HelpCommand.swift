//
//  HelpCommand.swift
//  App
//
//  Created by Chris Martin on 4/22/18.
//

import Foundation
import Vapor

struct HelpCommand: UserCommand {
    
    static var keyword: String {
        return "help"
    }
    
    static var description: String {
        return "Get help on how to use Jarvis"
    }
    
    static var commandLength: CommandLength {
        return .zero
    }
    
    init(contents: String?, request: UserCommandRequest) throws { }
    
    func reply(using container: Container) throws -> Future<Reply> {
        
        let commandService = try container.make(CommandService.self)
        let commandDescriptions = commandService.descriptions
        
        var message = "/jarvis {command} {arguments}"
        for command in commandDescriptions {
            message += "\n    • *\(command.name):* _\(command.description)_"
        }
        
        return Reply(text: message, replyType: .ephemeral).future(on: container)
    }
}
