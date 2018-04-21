//
//  EventController.swift
//  App
//
//  Created by Chris Martin on 4/14/18.
//

import Vapor

final class EventController: RouteCollection {
    
    func boot(router: Router) throws {
        
        let eventGroup = router.grouped("slack", "event")
        eventGroup.post(use: challenge)
    }
    
    func handle(request: Request) throws -> Future<Any> {
        
        return try request.content
            .decode(Challenge.self)
            .map(to: Any.self) {
                try $0.validate()
                return $0.challenge
        }
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
        
        print(req.content)
        
        return try req.content.decode(SlackEventRequest.self)
            .map(to: Void.self) { try $0.validate() }
            .transform(to: .ok)
    }
}
