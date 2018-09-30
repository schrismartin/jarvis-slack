import Vapor

/// Controlers basic CRUD operations on `Todo`s.
final class TodoController: RouteCollection {
    
    func boot(router: Router) throws {
        
        let todoGroup = router.grouped("api", "todo")
        todoGroup.get(use: index)
        todoGroup.post(use: create)
    }
    
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[Todo]> {
        return Todo.query(on: req).all()
    }

    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request) throws -> Future<Todo> {
        return try req.content.decode(Todo.self).flatMap(to: Todo.self) { todo in
            return todo.save(on: req)
        }
    }
}
