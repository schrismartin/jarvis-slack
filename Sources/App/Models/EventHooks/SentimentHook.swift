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
    
    init(event: Event) throws {
        
        guard !event.isSlashCommand else {
            throw UserCommandError.unsupportedOperation
        }

        self.event = event
    }
    
    func handleEvent(on worker: Container) throws -> Future<Event> {
        
        return worker.withPooledConnection(to: .psql) { conn in
            try Sentiment.create(for: self.event, on: worker)
                .save(on: conn)
                .always { try? worker.releasePooledConnection(conn, to: .psql) }
        }
        .transform(to: event)
    }
}
