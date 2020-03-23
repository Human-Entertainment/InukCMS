//
//  File.swift
//  
//
//  Created by Bastian Inuk Christensen on 23/03/2020.
//

import Vapor

struct PostsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let postGroup = routes.grouped("posts")
        postGroup.post("", use: addPost)
    }
    
    func addPost(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let post = try req.content.decode(Post.self)
        return post.save(on: req.db).map{
            HTTPStatus.ok
        }
    }
}
