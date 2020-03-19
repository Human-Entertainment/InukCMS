//
//  File.swift
//  
//
//  Created by Bastian Inuk Christensen on 19/03/2020.
//

import Fluent
import Plot
import Ink

typealias Slug = String
typealias MarkDown = String

final class Post: Model {
    static var schema: String = "post"
    
    @ID(key:"id")
    var id: UUID?
    
    @Field(key:"slug")
    var slug: Slug
    
    @Field(key:"title")
    var title: String
    
    @Field(key:"body")
    var _body: MarkDown
    
    var body: MarkDown {
        get {
            var parser = MarkdownParser()
            let markdown: String = _body
            return parser.html(from: markdown)
        }
        set(markdown) {
            _body = markdown
        }
    }
    
    @Field(key:"roles")
    var roles: PostRole
    
    init(){}

    /**
        The model representing a post or site on the webstie
        - Parameters:
            -  id: The id of the post, this is unique and is possibly always unique
            - slug: This is to get the post from the website, also has to be unique
            - title: The title to be displayed on the top of the page
            - body: A markdown or html representation of the page, this uses plot to render
            - roles: Some posts and pages have special roles, should they be displayed in the navbar, shown as a blog etc. See `PostRoles` for more info
     */
    init(id: UUID? = nil, slug: Slug? = nil, title: String, body: MarkDown, roles: PostRole = .blogPost) {
        self.id = id
        self.slug = slug ?? title
        self.title = title
        self.body = body
        self.roles = roles
    }
}

struct PostRole: Codable, OptionSet {
    init(rawValue: UInt64) {
        self.rawValue = rawValue
    }
    
    let rawValue: UInt64
    
    func encode(to encoder: Encoder) throws {
      try rawValue.encode(to: encoder)
    }
    
    init(from decoder: Decoder) throws {
      rawValue = try .init(from: decoder)
    }
    
    static let blogPost = PostRole(rawValue: 1)
    static let navBar = PostRole(rawValue: 1 << 1)
}
