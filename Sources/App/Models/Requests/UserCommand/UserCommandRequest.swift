//
//  UserCommand.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Foundation
import Vapor
import Validation

final class UserCommandRequest: SlackRequest {
    
    var token: String
    var teamID: String
    var teamDomain: String
    var channelID: String
    var channelName: String
    var userID: String
    var userName: String
    var command: String
    var text: String
    var triggerID: String
    
    enum CodingKeys: String, CodingKey {
        
        case token
        case teamID = "team_id"
        case teamDomain = "team_domain"
        case channelID = "channel_id"
        case channelName = "channel_name"
        case userID = "user_id"
        case userName = "user_name"
        case command
        case text
        case triggerID = "trigger_id"
    }
    
    func parse() throws -> UserCommand {
        
        var phrase = text.split(separator: " ")
        
        switch phrase.popFirst()?.lowercased() {
        case EchoCommand.keyword:
            return EchoCommand(contents: phrase.joined(separator: " "))
            
        default:
            throw UserCommandError(message: "This operation is not supported.")
        }
    }
}

extension UserCommandRequest: TokenValidatable { }
