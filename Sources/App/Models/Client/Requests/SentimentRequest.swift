//
//  SentimentRequest.swift
//  App
//
//  Created by Chris Martin on 5/6/18.
//

import Foundation
import Vapor

struct GetSentimentRequest: Content {
    
    var text: String
}

extension GetSentimentRequest {
    
    init(from event: Event) {
        
        self.text = event.text
    }
}

extension GetSentimentRequest: ContentClientRequest {
    
    static var method: HTTPMethod {
        return .GET
    }
    
    static var headers: HTTPHeaders {
        return [
            "X-AYLIEN-TextAPI-Application-Key": Environment.sentimentAPIKey,
            "X-AYLIEN-TextAPI-Application-ID": Environment.sentimentAppID
        ]
    }
    
    static var destination: URLRepresentable {
        return Constants.URLs.sentiment
    }
}
