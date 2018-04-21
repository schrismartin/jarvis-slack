import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {

    router.get("hello") { req in
        return "Hello, world!"
    }
    
    let eventController = EventController()
    try router.register(collection: eventController)
    
    let commandController = JarvisCommandController()
    try router.register(collection: commandController)
}
