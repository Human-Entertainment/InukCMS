//
//  File.swift
//  
//
//  Created by Bastian Inuk Christensen on 18/03/2020.
//

import Vapor
import Plot

struct IndexController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("", use: index)
    }
    
    func index(req: Request) throws -> EventLoopFuture<HTML> {
        Post.query(on: req.db).all().map{
            IndexViews.index(posts: $0)
        }
    }
}