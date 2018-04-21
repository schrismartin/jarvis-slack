//
//  CommandParser.swift
//  App
//
//  Created by Chris Martin on 4/21/18.
//

import Foundation
import Vapor

class CommandService {
    
    var commandTypes = [UserCommand.Type]()
    
    func register<U: UserCommand>(command: U.Type) {
        
        commandTypes.append(command)
    }
    
    func parseCommand(using text: String) throws -> UserCommand {
        
        let parser = try CommandParser(text: text)
        
        let commandType = commandTypes
            .first { $0.keyword == parser.command }
        
        guard let command = commandType?.init(contents: parser.body) else {
            throw UserCommandError(message: "Unrecognized command: \(parser.command)")
        }
        
        return command
    }
}

extension CommandService: Service { }
