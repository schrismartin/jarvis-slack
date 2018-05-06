//
//  SentimentHook.swift
//  App
//
//  Created by Chris Martin on 5/6/18.
//

import Foundation
import Vapor
import Fluent

struct SentimentHook: EventHook {
    
    var event: Event
    
    init(event: Event) {
        
        self.event = event
    }
    
    func handleEvent(on worker: Container) throws -> Future<Event> {
        
        print("Sentiment hook triggered at \(Date()).")
        
        return worker.withPooledConnection(to: .psql) { conn in
            try Sentiment.create(for: self.event, on: worker)
                .save(on: conn)
        }
        .transform(to: event)
    }
}
