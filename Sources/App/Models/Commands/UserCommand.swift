//
//  UserCommand.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Foundation
import Vapor

protocol UserCommand {
    
    static var keyword: String { get }
    
    init(contents: String)
    
    func generateFutureResponse(using container: Container) throws -> Future<UserCommandResponse>
}

protocol BasicUserCommand: UserCommand {
    
    func generateResponse() throws -> UserCommandResponse
}

extension BasicUserCommand {
    
    func generateFutureResponse(using container: Container) throws -> Future<UserCommandResponse> {
        
        let promise = container.eventLoop.newPromise(UserCommandResponse.self)
        let response = try generateResponse()
        promise.succeed(result: response)
        
        return promise.futureResult
    }
}
