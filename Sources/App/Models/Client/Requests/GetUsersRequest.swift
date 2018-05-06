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
}

extension GetUsersRequest: ContentClientRequest {
    
    static var method: HTTPMethod {
        return .GET
    }
    
    static var destination: URLRepresentable {
        return Constants.URLs.slackUsers
    }
}
