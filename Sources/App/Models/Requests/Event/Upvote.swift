//
//  Upvote.swift
//  App
//
//  Created by Chris Martin on 4/29/18.
//

import Foundation
import Vapor

class Upvote {
    
    var sender: User.ID
    var target: User.ID
    var count: Int = 1
    
    convenience init?(from event: Event) {
        
        let message = event.text
        
        let values = message.split(separator: " ")
        guard
            values.count == 2,
            let upvoteValue = values.first,
            upvoteValue == "+1",
            let user = values.last,
            let tag = UserTag(tag: String(user))
        else {
            return nil
        }
        
        self.init(
            sender: event.userID,
            target: tag.userID
        )
    }
    
    init(sender: User.ID, target: User.ID) {
        
        self.sender = sender
        self.target = target
    }
}
