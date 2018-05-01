
//
//  SlackMessage.swift
//  App
//
//  Created by Chris Martin on 4/30/18.
//

import Foundation
import Vapor

struct SlackMessage: Content {
    
    var channel: Channel.ID
    var text: String
    var attachments: [Attachment]
    
    init(text: String, channelID: Channel.ID, attachments: [Attachment] = []) throws {
        
        self.channel = channelID
        self.text = text
        self.attachments = attachments
    }
    
    func send(on worker: Container) throws -> Future<Response> {
        
        let client = try worker.make(Client.self)
        return try client.send(request: self)
    }
}

extension SlackMessage: SlackClientRequest {
    
    static var method: HTTPMethod {
        return .POST
    }
    
    static var destination: URLRepresentable {
        return "https://slack.com/api/chat.postMessage"
    }
}
