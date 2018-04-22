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
    var imageURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case text
        case imageURL = "image_url"
    }
    
    init(text: String?, imageURL: URL?) {
        
        self.text = text
        self.imageURL = imageURL
    }
}

extension Attachment {
    
    convenience init(text: String) {
        
        self.init(text: text, imageURL: nil)
    }
    
    convenience init(imageUrl: URL) {
        
        self.init(text: nil, imageURL: imageUrl)
    }
}
