import Fluent
import FluentPostgresDriver
import Vapor

// Called before your application initializes.
public func configure(_ app: Application) throws {
    // Serves files from `Public/` directory
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // Configure SQLite database
    app.databases.use(.postgres(
        hostname: Environment.get("PHostname") ?? "localhost",
        username: Environment.get("PUname") ?? "vapor",
        password: Environment.get("PPassword") ?? "password"
        ), as: .psql)
    // Configure migrations
    //app.migrations.add(CreateTodo())
    
    try routes(app)
}
