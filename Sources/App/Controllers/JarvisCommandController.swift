//
//  CommandController.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Vapor

/// Controller responding to the /jarvis command
final class JarvisCommandController: RouteCollection {
    
    func boot(router: Router) throws {
        
        let eventGroup = router.grouped("slack", "command")
        eventGroup.post(use: handleCommand)
    }
    
    func handleRequest(_ request: Request) throws -> Future<ResponseEncodable> {
        
        return try handleCommand(request).map { $0 as ResponseEncodable }
    }
    
    /// Handle sub-commands passed through /jarvis {keyword}
    /// and will respond to user errors.
    ///
    /// - Parameter request: Request object
    /// - Returns: Response to Slack
    /// - Throws: Vapor-specific errors
    func handleCommand(_ request: Request) throws -> Future<UserCommandResponse> {
        
        print(request)
        
        return try request.content.decode(UserCommandRequest.self)
            
            // Validate & Parse Command
            .map(to: UserCommand.self) {
                
                try $0.validate()
                let commandService = try request.make(CommandService.self)
                return try commandService.parseCommand(using: $0)
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
