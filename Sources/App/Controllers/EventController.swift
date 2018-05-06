//
//  EventController.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Vapor

final class EventController: BaseController, RouteCollection {
    
    func boot(router: Router) throws {
        
        let eventGroup = router.grouped("slack", "event")
        eventGroup.post(use: handleRequest)
    }
    
    func handleRequest(_ request: Request) throws -> Future<Response> {
        
        return try request.content.decode(EventDecider.self)
            .flatMap(to: ResponseEncodable.self) {
                
                switch $0.type {
                case .urlVerification:
                    return try self.challenge(request)
                        .map { $0 as ResponseEncodable }
                    
                case .eventCallback:
                    return try self.handleEvent(request)
                        .map { $0 as ResponseEncodable }
                }
            }
            .flatMap(to: Response.self) { try $0.encode(for: request) }
    }
    
    func challenge(_ req: Request) throws -> Future<String> {
        
        return try req.content
            .decode(Challenge.self)
            .map(to: String.self) {
                try $0.validate()
                return $0.challenge
            }
    }
    
    func handleEvent(_ req: Request) throws -> Future<HTTPStatus> {
        
        return try req.content.decode(SlackEventRequest.self)
            .map(to: SlackEventRequest.self) { try $0.validate(); return $0 }
            .flatMap(to: Event.self) { Event(from: $0).create(on: req) }
            .flatMap(to: Event.self) { try self.performHooks(for: $0, on: req) }
            .transform(to: .ok)
            .catchMap { error in
                try self.log(error: error, in: req)
                return .ok
        }
    }
    
    func performHooks(for event: Event, on worker: Container) throws -> Future<Event> {
        
        let eventService = try worker.make(EventService.self)
        return eventService.handle(event: event, on: worker)
    }
}
