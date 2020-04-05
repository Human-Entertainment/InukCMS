//
//  File.swift
//  
//
//  Created by Bastian Inuk Christensen on 23/03/2020.
//

import Fluent
import PostgresKit

struct CreatePost: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("posts")
            .id()
            .field("slug", .string, .required)
            .field("title", .string, .required)
            .field("body", .string, .required)
            .field("roles", .uint64, .required)
            .unique(on: "slug")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("posts").delete()
    }
}
