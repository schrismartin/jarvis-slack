//
//  EventService.swift
//  App
//
//  Created by Chris Martin on 4/29/18.
//

import Foundation
import Vapor

class EventService {
    
    private var registeredHooks = [EventHook.Type]()
    
    func register<U: EventHook>(hook: U.Type) {
        
        registeredHooks.append(hook)
    }
    
    func handle(event: Event, on worker: Container) -> Future<Event> {
        
        let future = Future.map(on: worker) { event }
        return registeredHooks.reduce(future) { (future, hook) -> Future<Event> in
            future.flatMap(to: Event.self) { (event) -> Future<Event> in
                do {
                    return try hook.init(event: event)
                    .handleEvent(on: worker)
                    .catch { print($0) }
                }
                catch {
                    print(error)
                    return Future.map(on: worker) { event }
                }
            }
        }
    }
}

extension EventService: Service { }

protocol EventHook {
    
    init(event: Event)
    
    func handleEvent(on worker: Container) throws -> Future<Event>
}
