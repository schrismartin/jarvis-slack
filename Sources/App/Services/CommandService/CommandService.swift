//
//  CommandParser.swift
//  App
//
//  Created by Chris Martin on 4/21/18.
//

import Foundation
import Vapor

/// Used to register and parse commands.
class CommandService {
    
    typealias CommandDescription = (name: String, description: String)
    
    /// Registered commands
    private var registeredCommandTypes = [UserCommand.Type]()
    
    var descriptions: [CommandDescription] {
        
        return registeredCommandTypes.map {
            
            CommandDescription(
                name: $0.keyword,
                description: $0.description
            )
        }
    }
    
    /// Register a command to be invoked
    ///
    /// - Parameter command: Command to be registered
    func register<U: UserCommand>(command: U.Type) {
        
        registeredCommandTypes.append(command)
    }
    
    /// Parse the text and return the correct command object.
    ///
    /// - Parameter text: Text to be parsed
    /// - Returns: Command resulting from parsed text
    /// - Throws:
    ///    - Unrecognized Command Error
    ///    -
    func parseCommand(using request: UserCommandRequest) throws -> UserCommand {
        
        let text = request.text
        let parser = try CommandParser(text: text)
        
        let potentialCommandType = registeredCommandTypes
            .first { $0.keyword == parser.command }
        
        guard let commandType = potentialCommandType else {
            throw UserCommandError.unrecognizedCommand(parser.command)
        }
        
        guard parser.satisfies(commandType.commandLength) else {
            throw UserCommandError.invalidNumberOfArguments(expected: commandType.commandLength)
        }
        
        return try commandType.init(
            contents: parser.body,
            request: request
        )
    }
}

extension CommandService: Service { }
