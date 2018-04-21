//
//  Attachment.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Foundation
import Vapor

final class Attachment: Content {
    
    var text: String
    
    init(text: String) {
        
        self.text = text
    }
}
