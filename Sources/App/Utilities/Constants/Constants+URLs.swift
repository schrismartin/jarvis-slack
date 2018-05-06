//
//  Constants+URLs.swift
//  App
//
//  Created by Chris Martin on 4/22/18.
//

import Foundation

extension Constants.URLs {
    
    static let inspirobot: URL = URL(string: "http://inspirobot.me/api?generate=true")!
    static let slackUsers: URL = URL(string: "https://slack.com/api/users.list")!
    static let sentiment: URL = URL(string: "https://api.aylien.com/api/v1/sentiment")!
}
