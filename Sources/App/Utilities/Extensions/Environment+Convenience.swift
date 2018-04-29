//
//  Environment+Convenience.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Vapor

extension Environment {
    
    static var slackToken: String {
        
        return get(Constants.Environment.slackToken) ?? "dev-slack-token"
    }
    
    static var botToken: String? {
        
        return get(Constants.Environment.botToken)
    }
}
