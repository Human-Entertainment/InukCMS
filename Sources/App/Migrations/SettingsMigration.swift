import Fluent
import PostgresKit

struct SettingsMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("preferences")
            .id()
            .field("title", .string, .required)
            .create()
        
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("preferences").delete()
    }
}
