import Routing
import Vapor

/// Called after your application has initialized.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#bootswift)
public func boot(_ app: Application) throws {
    
    try fetchUsers(using: app)
}

@discardableResult
func fetchUsers(using app: Application) throws -> Future<[User]> {
    
    let client = try app.make(Client.self)
    let token = try Environment.botToken.unwrapped()
    let request = GetUsersRequest(token: token)
    
    return app.withPooledConnection(to: .psql) { connection -> Future<[User]> in
        return try client.send(request: request)
            .flatMap(to: [User].self) { $0.content.get([User].self, at: "members") }
            .map(to: [Future<User>].self) { $0.map { $0.create(on: connection) } }
            .flatMap(to: [User].self) { $0.flatten(on: app) }
    }
}
