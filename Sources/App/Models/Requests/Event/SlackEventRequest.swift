//
//  SlackResponse.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Foundation
import Vapor
import Validation

final class SlackEventRequest: SlackRequest {
    
    var token: String
    var event: Event
}
