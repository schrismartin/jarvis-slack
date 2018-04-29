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
    
    /// Register CommandService
    let commandService = CommandService()
    commandService.register(command: EchoCommand.self)
    commandService.register(command: ComplimentCommand.self)
    commandService.register(command: InsultCommand.self)
    commandService.register(command: InspireCommand.self)
    commandService.register(command: HelpCommand.self)
    services.register(commandService)
    
    services.register(ComplimentGenerator())
    services.register(InsultGenerator())
    
    /// Register middleware
    var middlewares = MiddlewareConfig()
    middlewares.use(DateMiddleware.self)
    middlewares.use(ErrorMiddleware.self)
    services.register(middlewares)
    
    /// Content Config
    var contentConfig = ContentConfig.default()
    let jsonDecoder = JSONDecoder()
    jsonDecoder.dateDecodingStrategy = .secondsSince1970String
    contentConfig.use(decoder: jsonDecoder, for: .json)
    services.register(contentConfig)

    try configureDatabase(using: env, for: &services)
}

fileprivate func configureDatabase(using env: Environment, for services: inout Services) throws {
    
    let database = try createDatabase(for: env)
    var databases = DatabaseConfig()
    databases.add(database: database, as: .psql)
    services.register(databases)
    
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: Event.self, database: .psql)
    services.register(migrations)
}

fileprivate func createDatabase(for env: Environment) throws -> PostgreSQLDatabase {
    
    if env.isRelease {
        
        guard
            let urlString = Environment.get(Constants.Environment.databaseURL),
            let databaseURL = URL(string: urlString)
        else {
            throw ServiceError(
                identifier: "Environmnent",
                reason: "Env variable \(Constants.Environment.databaseURL) does not exist"
            )
        }
        
        let config = try PostgreSQLDatabaseConfig(from: databaseURL)
        return PostgreSQLDatabase(config: config)
    }
    else {
        
        let config = PostgreSQLDatabaseConfig(
            hostname: "localhost",
            username: "schrismartin",
            database: "jarvis"
        )
        
        return PostgreSQLDatabase(config: config)
    }
}
