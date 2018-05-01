//
//  SlackClientRequest.swift
//  App
//
//  Created by Chris Martin on 4/29/18.
//

import Foundation
import Vapor

protocol SlackClientRequest: ContentClientRequest { }

extension SlackClientRequest {
    
    static var headers: HTTPHeaders {
        
        if let token = Environment.botToken {
            return ["Authorization": "Bearer \(token)"]
        }
        else {
            return [:]
        }
    }
}
