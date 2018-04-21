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
    
    convenience init(contents text: String) {
        
        self.init(text: text, replyType: .inChannel, attachments: [])
    }
    
    static var keyword: String {
        return "echo"
    }
    
    func generateResponse() throws -> UserCommandResponse {
        return self
    }
}
