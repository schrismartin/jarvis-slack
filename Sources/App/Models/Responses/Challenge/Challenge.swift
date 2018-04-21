//
//  Challenge.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Foundation
import Vapor
import Validation

struct Challenge: SlackRequest, SlackResponse {
    
    var token: String
    var challenge: String
    var type: String
}
