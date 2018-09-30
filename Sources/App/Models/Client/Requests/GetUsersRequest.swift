//
//  GetUsersRequest.swift
//  App
//
//  Created by Chris Martin on 4/29/18.
//

import Foundation
import Vapor

struct GetUsersRequest: Content {
    
    var token: String
    var limit: Int
    
    init(token: String) {
        
        self.token = token
        limit = 200
    }
}

extension GetUsersRequest: ContentClientRequest {
    
    static var method: HTTPMethod {
        return .GET
    }
    
    static var destination: URLRepresentable {
        return Constants.URLs.slackUsers
    }
}
