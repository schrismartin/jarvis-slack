//
//  Attachment.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Foundation
import Vapor

final class Attachment: Content {
    
    var text: String?
    var imageUrl: URL?
    
    init(text: String?, imageUrl: URL?) {
        
        self.text = text
        self.imageUrl = imageUrl
    }
}

extension Attachment {
    
    convenience init(text: String) {
        
        self.init(text: text, imageUrl: nil)
    }
    
    convenience init(imageUrl: URL) {
        
        self.init(text: nil, imageUrl: imageUrl)
    }
}
