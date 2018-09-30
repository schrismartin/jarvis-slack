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
    
    registerCommands(using: &services)
    
    /// Register Command-related Services
    services.register(ComplimentGenerator())
    services.register(InsultGenerator())
    
    registerEventService(using: &services)
    
    /// Register Upvotes
    services.register(UpvoteService())
    
    /// Register middleware
    var middlewares = MiddlewareConfig()
    middlewares.use(ErrorMiddleware.self)
    services.register(middlewares)
    
    /// Pool Config
    let poolConfig = DatabaseConnectionPoolConfig(maxConnections: 15)
    services.register(poolConfig)
    
    /// Content Config
    var contentConfig = ContentConfig.default()
    let jsonDecoder = JSONDecoder()
    jsonDecoder.dateDecodingStrategy = .secondsSince1970String
    contentConfig.use(decoder: jsonDecoder, for: .json)
    services.register(contentConfig)

    try configureDatabase(using: env, for: &services)
}

fileprivate func registerEventService(using services: inout Services) {
    
    let eventService = EventService()
    eventService.register(hook: VoteHook.self)
    eventService.register(hook: SentimentHook.self)
    services.register(eventService)
}

fileprivate func configureDatabase(using env: Environment, for services: inout Services) throws {
    
    let database = try createDatabase(for: env)
    var databases = DatabasesConfig()
    databases.add(database: database, as: .psql)
    services.register(databases)
    
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: Channel.self, database: .psql)
    migrations.add(model: Event.self, database: .psql)
    migrations.add(model: Upvote.self, database: .psql)
    migrations.add(model: Sentiment.self, database: .psql)
    services.register(migrations)
}

fileprivate func registerCommands(using services: inout Services) {
    
    let commandService = CommandService()
    commandService.register(command: EchoCommand.self)
    commandService.register(command: ComplimentCommand.self)
    commandService.register(command: InsultCommand.self)
    commandService.register(command: InspireCommand.self)
    commandService.register(command: IdentifyCommand.self)
    commandService.register(command: UpvotesCommand.self)
    commandService.register(command: SentimentCommand.self)
    commandService.register(command: PingCommand.self)
    commandService.register(command: HelpCommand.self)
    services.register(commandService)
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
