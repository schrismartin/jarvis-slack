//
//  RequestType.swift
//  App
//
//  Created by Chris Martin on 4/22/18.
//

import Foundation
import Vapor

enum RequestType: String, Codable {
    
    case urlVerification = "url_verification"
    case eventCallback = "event_callback"
}

struct EventDecider: Codable {
    
    var type: RequestType
}
