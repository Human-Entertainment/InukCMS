import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: IndexController())
    try app.register(collection: PostsController())
    try app.register(collection: AdminController())
}
