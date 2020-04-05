//
//  File.swift
//  
//
//  Created by Bastian Inuk Christensen on 23/03/2020.
//

import Vapor
import Fluent
import Plot

struct PostsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let postGroup = routes.grouped("posts")
        postGroup.post("", use: addPost)
        postGroup.get(":slug", use: getPost)
    }
    
    func addPost(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let post = try req.content.decode(PostCreation.self)
        return post.toDBModel()
            .save(on: req.db)
            .map{
                .created
            }
    }
    
    func getPost(req: Request) throws -> EventLoopFuture<HTML> {
        let slug = req.parameters.get("slug")! as Slug
        return Post.query(on: req.db)
            .filter( \.$slug == slug )
            .first()
            .flatMap { post in
                Post.getNav(on: req.db).flatMapThrowing { navLinks -> HTML in
                    guard let post = post else { throw Abort(.notFound) }
                    return IndexViews.postView(navLinks: navLinks, post)
                }
            }
    }
}
