import Vapor

struct AdminController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let admin = routes.grouped("admin")
        admin.put("preferences", use: preferences)
    }
    
    func preferences(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let preference = try req.content.decode(Settings.self)
        
        return preference.save(on: req.db).map {
            .created
        }
    }
}
