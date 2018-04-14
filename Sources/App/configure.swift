import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
///
/// https://docs.vapor.codes/3.0/getting-started/structure/#configureswift
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    
    /// Register providers first
    let postgresProvider = FluentPostgreSQLProvider()
    try services.register(postgresProvider)

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig()
    middlewares.use(DateMiddleware.self)
    middlewares.use(ErrorMiddleware.self)
    services.register(middlewares)

    try configureDatabase(using: env, for: &services)
}

fileprivate func configureDatabase(using env: Environment, for services: inout Services) throws {
    
    let database = try createDatabase(for: env)
    var databases = DatabaseConfig()
    databases.add(database: database, as: .psql)
    services.register(databases)
    
    let migrations = MigrationConfig()
    //    migrations.add(model: Todo.self, database: .psql)
    services.register(migrations)
}

fileprivate func createDatabase(for env: Environment) throws -> PostgreSQLDatabase {
    
    if env.isRelease {
        
        guard let databaseURL = Environment.get(Constants.Environment.databaseURL) else {
            throw ServiceError(
                identifier: "Environmnent",
                reason: "Env variable \(Constants.Environment.databaseURL) does not exist"
            )
        }
        
        let config = try PostgreSQLDatabaseConfig(url: databaseURL)
        return PostgreSQLDatabase(config: config)
    }
    else {
        
        let config = PostgreSQLDatabaseConfig(
            hostname: "localhost",
            username: "vapor",
            database: "vapor",
            password: "password"
        )
        
        return PostgreSQLDatabase(config: config)
    }
}
