//
//  SlackWebhook.swift
//  App
//
//  Created by Chris Martin on 4/19/18.
//

import Foundation
import Vapor

protocol SlackRequest: Content, TokenValidatable {
    
    var token: String { get set }
}
