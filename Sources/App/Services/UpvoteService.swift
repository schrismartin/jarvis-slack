//
//  UpvoteService.swift
//  App
//
//  Created by Chris Martin on 4/30/18.
//

import Foundation
import Vapor
import Fluent

class UpvoteService: Service {
    
    func countUpvotes(for user: User, on worker: Container) throws -> Future<Int> {
        
        return worker.withPooledConnection(to: .psql) { conn in
            
            /// TODO: Switch to this whenever possible.
            // let upvoteCount = user.flatMap(to: Int.self) { try $0.upvotes.query(on: conn)
            //    .aggregate(.sum, field: \Upvote.count) }
            
            try user.upvotes.query(on: conn).all()
                .map(to: Int.self) { $0.map { $0.count }.reduce(0, +) }
        }
    }
    
    func countUpvotes(using userID: User.ID, on worker: Container) throws -> Future<Int> {
        
        return worker.withPooledConnection(to: .psql) { conn in
            try User.fetch(with: userID, on: conn)
        }
            
        .flatMap(to: Int.self) { user in
            try self.countUpvotes(for: user, on: worker)
        }
    }
}
