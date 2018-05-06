//
//  UserTag.swift
//  App
//
//  Created by Chris Martin on 4/29/18.
//

import Foundation
import FluentPostgreSQL

struct UserTag {
    
    var userID: User.ID
    var username: String?
    
    init?(tag: String) {
        
        let values = tag.trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
        let components = values.split(separator: "|")
        
        guard let userID = components.first, userID.first == "@" else { return nil }
        let username = components.last
        
        self.init(
            userID: String(userID).trimmingCharacters(in: CharacterSet(charactersIn: "@")),
            username: username.flatMap(String.init)
        )
    }
    
    init(userID: User.ID, username: String?) {
        
        self.userID = userID
        self.username = username
    }
    
    var tagValue: String {
        
        if let username = username {
            return "<@\(userID)|\(username)>"
        }
        else {
            return "<@\(userID)>"
        }
    }
}
