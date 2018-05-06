//
//  Sentiment.swift
//  App
//
//  Created by Chris Martin on 5/6/18.
//

import Foundation
import Vapor
import Fluent
import FluentPostgreSQL

final class Sentiment: Codable {

    var id: Int?
    var eventID: Event.ID
    var positivity: Double
    var objectivity: Double
    
    init(event: Event, positivity: Double, objectivity: Double) throws {
        
        self.eventID = try event.requireID()
        self.positivity = positivity
        self.objectivity = objectivity
    }
}

// MARK: - Creation
extension Sentiment {
    
    static func create(for event: Event, on worker: Container) throws -> Future<Sentiment> {
        
        let client = try worker.make(Client.self)
        let request = GetSentimentRequest(from: event)
        return try client.send(request: request)
            .flatMap(to: SentimentResponse.self) { try $0.content.decode(SentimentResponse.self) }
            .map(to: Sentiment.self) { try Sentiment(for: event, using: $0) }
    }
    
    convenience init(for event: Event, using sentimentResponse: SentimentResponse) throws {
        
        try self.init(
            event: event,
            positivity: sentimentResponse.positivity,
            objectivity: sentimentResponse.objectivity
        )
    }
}

// MARK: - Queries
extension Sentiment {
    
    private static func sentimentQuery(for user: User, on worker: Container) throws -> Future<QueryBuilder<Sentiment, Sentiment>> {
        
        return worker.withPooledConnection(to: .psql) { conn in
            try user.events.query(on: conn).all()
                .map(to: [Event.ID].self) { $0.compactMap { $0.id } }
                .map(to: QueryBuilder<Sentiment, Sentiment>.self) { ids in
                    try conn.query(Sentiment.self)
                        .filter(\Sentiment.eventID ~~ ids)
            }
        }
    }
    
    static func allSentiments(for user: User, on worker: Container) throws -> Future<[Sentiment]> {
        
        return try sentimentQuery(for: user, on: worker)
            .flatMap(to: [Sentiment].self) { $0.all() }
    }
    
    static func averagePositivity(for user: User, on worker: Container) throws -> Future<Double> {
        
        return try sentimentQuery(for: user, on: worker)
            .flatMap(to: Double.self) { try $0.average(\.positivity) }
    }
    
    static func averageObjectivity(for user: User, on worker: Container) throws -> Future<Double> {
        
        return try sentimentQuery(for: user, on: worker)
            .flatMap(to: Double.self) { try $0.average(\.objectivity) }
    }
}

// MARK: - Relationships
extension Sentiment {
    
    var event: Parent<Sentiment, Event> {
        return parent(\.eventID)
    }
}

extension Sentiment: PostgreSQLModel { }
extension Sentiment: Migration { }
