//
//  UserCommand.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Foundation
import Vapor
import FluentPostgreSQL
import Validation

final class UserCommandRequest: SlackRequest {
    
    var id: UserCommandRequest.ID?
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
}

extension UserCommandRequest: PostgreSQLModel {
    
    var user: Parent<UserCommandRequest, User> {
        
        return parent(\.userID)
    }
}

extension UserCommandRequest: Migration { }
