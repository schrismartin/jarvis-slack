//
//  UserCommandResponse.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Foundation
import Vapor

final class UserCommandResponse: SlackResponse {
    
    var text: String
    var replyType: ReplyType
    var attachments: [Attachment]
    
    enum CodingKeys: String, CodingKey {
        case text
        case replyType = "response_type"
        case attachments
    }
    
    init(text: String, replyType: ReplyType = .inChannel, attachments: [Attachment] = []) {
        
        self.text = text
        self.replyType = replyType
        self.attachments = attachments
    }
}

extension UserCommandResponse: BasicUserCommand {
    
    static var commandLength: CommandLength {
        return .unbounded
    }
    
    convenience init(contents text: String?, request: UserCommandRequest) throws {
        
        self.init(
            text: try text.unwrapped(),
            replyType: .inChannel,
            attachments: []
        )
    }
    
    static var keyword: String {
        return "response"
    }
    
    func generateResponse(using container: Container) throws -> UserCommandResponse {
        return self
    }
}
