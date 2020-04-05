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
        Post.query(on: req.db)
            .all()
            .and(Post.getNav(on: req.db))
            .and(Settings.query(on: req.db).first())
            .map{ pageTuple in
                let settings = pageTuple.1
                let navPosts = pageTuple.0.1
                let posts = pageTuple.0.0
                return IndexViews.index(title: settings?.title ?? "Inuk Entertainment" ,navPosts, posts: posts)
            }
    }
}
