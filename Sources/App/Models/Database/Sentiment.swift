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

protocol SentimentRepresentable {
    
    var polarity: Double { get }
    var polarityConfidence: Double { get }
    var objectivity: Double { get }
    var objectivityConfidence: Double { get }
}

extension SentimentRepresentable {
    
    var polarityDifferential: Double {
        return 1 - polarityConfidence
    }
    
    var objectivityDifferential: Double {
        return 1 - objectivityConfidence
    }
}

final class Sentiment: Codable, SentimentRepresentable {

    var id: Int?
    var eventID: Event.ID
    var polarity: Double
    var polarityConfidence: Double
    var objectivity: Double
    var objectivityConfidence: Double
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case eventID = "event_id"
        case polarity
        case polarityConfidence = "polarity_confidence"
        case objectivity
        case objectivityConfidence = "objectivity_confidence"
    }
    
    init(
        event: Event,
        polarity: SentimentPolarity,
        polarityConfidence: Double,
        objectivity: SentimentSubjectivity,
        objectivityConfidence: Double
    ) throws {
        
        self.eventID = try event.requireID()
        self.polarity = Double(polarity.polarity)
        self.polarityConfidence = polarityConfidence
        self.objectivity = Double(objectivity.polarity)
        self.objectivityConfidence = objectivityConfidence
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
            polarity: sentimentResponse.polarity,
            polarityConfidence: sentimentResponse.polarityConfidence,
            objectivity: sentimentResponse.subjectivity,
            objectivityConfidence: sentimentResponse.subjectivityConfidence
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
            .flatMap(to: Double.self) { try $0.average(\.polarity) }
    }
    
    static func averageObjectivity(for user: User, on worker: Container) throws -> Future<Double> {
        
        return try sentimentQuery(for: user, on: worker)
            .flatMap(to: Double.self) { try $0.average(\.objectivity) }
    }
    
    static func numberOfEntries(for user: User, on worker: Container) throws -> Future<Int> {
        
        return try sentimentQuery(for: user, on: worker)
            .flatMap(to: Int.self) { $0.count() }
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

extension Array: SentimentRepresentable where Array.Element: SentimentRepresentable {
    
    var polarity: Double {
        return (try? map { $0.polarity }.averaged()) ?? 0
    }
    
    var polarityConfidence: Double {
        return (try? map { $0.polarityConfidence }.averaged()) ?? 0
    }
    
    var objectivity: Double {
        return (try? map { $0.objectivity }.averaged()) ?? 0
    }
    
    var objectivityConfidence: Double {
        return (try? map { $0.objectivityConfidence }.averaged()) ?? 0
    }
}
