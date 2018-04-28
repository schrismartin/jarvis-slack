import Routing
import Vapor

/// Called after your application has initialized.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#bootswift)
public func boot(_ app: Application) throws {
    // your code here
    
    try fetchUsers(using: app)
}

func fetchUsers(using container: Container) throws {
    
    let client = try container.make(Client.self)
//    client.get(<#T##url: URLRepresentable##URLRepresentable#>)
}
