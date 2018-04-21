//
//  UserCommand.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Foundation
import Vapor

protocol UserCommand {
    
    /// This command will be envoked using this keyword
    static var keyword: String { get }
    
    /// This command is expected to have this number of words, including the command
    static var commandLength: CommandLength { get }
    
    /// Create this command with these words
    ///
    /// - Parameter contents: Additonal contents of the command
    init(contents: String?, request: UserCommandRequest) throws
    
    /// Create a future response as the result of this command
    ///
    /// - Parameter container: Container from which the command is running
    /// - Returns: Response seen by the user
    func generateFutureResponse(using container: Container) throws -> Future<UserCommandResponse>
}

protocol BasicUserCommand: UserCommand {
    
    /// Create a response as the result of this command
    ///
    /// - Returns: Response seen by the user
    func generateResponse(using container: Container) throws -> UserCommandResponse
}

extension BasicUserCommand {
    
    func generateFutureResponse(using container: Container) throws -> Future<UserCommandResponse> {
        
        let promise = container.eventLoop.newPromise(UserCommandResponse.self)
        let response = try generateResponse(using: container)
        promise.succeed(result: response)
        
        return promise.futureResult
    }
}
