//
//  CommandController.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Vapor

final class CommandController: RouteCollection {
    
    func boot(router: Router) throws {
        
        let eventGroup = router.grouped("slack", "command")
        eventGroup.post(use: handleEvent)
    }
    
    func handleEvent(_ request: Request) throws -> Future<UserCommandResponse> {
        
        return try request.content.decode(UserCommandRequest.self)
            
            // Validate & Parse Command
            .map(to: UserCommand.self) {
                
                try $0.validate()
                let commandService = try request.make(CommandService.self)
                return try commandService.parseCommand(using: $0.text)
            }
            
            // Create a response
            .flatMap(to: UserCommandResponse.self) {
                
                try $0.generateFutureResponse(using: request)
            }
            
            // Handle errors
            .catchMap { (error) -> UserCommandResponse in
                
                guard let commandError = error as? UserCommandError else {
                    throw error
                }
                
                return commandError.response
            }
    }
}
