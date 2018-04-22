//
//  InspireCommand.swift
//  App
//
//  Created by Chris Martin on 4/22/18.
//

import Foundation
import Vapor

struct InspireCommand: UserCommand {
    
    static var keyword: String {
        return "inspire"
    }
    
    static var description: String {
        return "Create an AI-generated inspirational poster!"
    }
    
    static var commandLength: CommandLength {
        return .zero
    }
    
    init(contents: String?, request: UserCommandRequest) throws { }
    
    func reply(using container: Container) throws -> Future<Reply> {
        
        return try container.make(Client.self)
            .get(Constants.URLs.inspirobot)
            .map(to: Data.self) { try $0.http.body.data.unwrapped() }
            .map(to: String.self) { try String(data: $0, encoding: .utf8).unwrapped() }
            .map(to: URL.self) { try URL(string: $0).unwrapped() }
            .map { Reply.inspirobot(imageURL: $0) }
    }
}

