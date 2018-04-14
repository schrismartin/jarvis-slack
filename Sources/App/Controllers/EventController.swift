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
    
    func challenge(_ req: Request) throws -> Future<String> {
        
        return try req.content
            .decode(Challenge.self)
            .map(to: String.self) {
                try $0.validate()
                return $0.challenge
            }
    }
}
