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

struct PostCreation: Decodable {
    var slug: Slug?
    
    var title: String?
    
    var body: MarkDown
    
    var roles: PostRole?
    
    func toDBModel() -> Post {
        .init(slug: slug, title: title, body: body, roles: roles ?? .blogPost)
    }
}

final class Post: Model {
    private let markdownParser = MarkdownParser()
    static var schema: String = "posts"
    
    @ID(key:"id")
    var id: UUID?
    
    @Field(key:"slug")
    var slug: Slug
    
    @Field(key:"title")
    var title: String
    
    @Field(key:"body")
    var body: MarkDown
    
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
    init(id: UUID? = nil, slug: Slug? = nil, title: String? = nil, body: MarkDown, roles: PostRole = .blogPost) {
        self.id = id
        self.body = body
        self.slug = slug ??
            title?
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ??
            markdownParser
                .parse(body)
                .title?
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.title = title ?? markdownParser.parse(body).title ?? ""
        self.roles = roles
    }

}
/*
extension Post {
    enum CodingKeys: String, CodingKey {
        case body
        case title
        case slug
        case roles
    }
    
    convenience init(from decoder: Decoder) throws
    {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.body = try values.decode(MarkDown.self, forKey: .body)
        let decodedTitle = try? values.decode(String.self, forKey: .title)
        let parsedTitle = decodedTitle ?? markdownParser.parse(body).title
        if let title = parsedTitle {
            self.title = title
        } else {
            throw ParseError.noTitle
        }
        let decodedSlug = try? values.decode(Slug.self, forKey: .slug)
        let parsedSlug = decodedSlug ?? parsedTitle?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let slug = parsedSlug {
            self.slug = slug
        } else {
            throw ParseError.noSlug
        }
        
        
        let roles = try? values.decode(PostRole.self, forKey: .roles)
        print(roles?.rawValue)
        self.roles = roles ?? .blogPost
    }
}

*/
enum ParseError: Error {
    case noTitle
    case noSlug
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

extension Post: CustomStringConvertible {
    var description: String { return self.title }
}

extension Post {
    /// Renders a HTML body from body
    var htmlBody: String {
        markdownParser
            .html(from: body)
    }
}

extension Post {
    static func getNav(on db: Database) -> EventLoopFuture<[Post]> {
        Post.query(on: db)
            .all()
            .map { posts in
                return posts.compactMap { post in
                    if post.roles.contains(.navBar) {
                        return post
                    } else {
                        return nil
                    }
                }
            }
    }
}
