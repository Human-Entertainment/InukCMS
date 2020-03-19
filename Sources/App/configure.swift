import Fluent
import FluentPostgresDriver
import Vapor

// Called before your application initializes.
public func configure(_ app: Application) throws {
    // Serves files from `Public/` directory
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // Configure SQLite database
    app.databases.use(.postgres(
        hostname: Environment.get("POSTGRES_HOSTNAME") ?? "localhost",
        username: Environment.get("POSTGRES_USER") ?? "vapor_username",
        password: Environment.get("POSTGRES_PASSWORD") ?? "vapor_password",
        database: Environment.get("POSTGRES_DB") ?? "vapor_database"
    ), as: .psql)
    // Configure migrations
    //app.migrations.add(CreateTodo())
    
    try routes(app)
}
