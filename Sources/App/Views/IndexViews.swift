//
//  File.swift
//  
//
//  Created by Bastian Inuk Christensen on 18/03/2020.
//

import Plot

struct IndexViews {
    
    /**
      A short template function, which all
     - Parameters:
        - title: The title of the page,
        - body: the body that's passed int the templat
     - Returns: A build HTML to be used by anything really
    */
    static func template(posts: [Post], title: String, _ body: () -> (Node<HTML.BodyContext>)) -> HTML {
        HTML(.head(.title(title)),
             .body(
                navbar(pages: posts),
                .main(body())
            )
        )
    }
    static func index(posts: [Post]) -> HTML {
        template(posts: posts, title: "Inuk Entatinment") {
            .raw("It worked")
        }
    }
    
    static func navbar(pages: [Post]) -> Node<HTML.BodyContext> {
        .nav(.group(
                .forEach(pages, {
                    .if($0.roles.contains(.navBar),
                        Node<HTML.BodyContext>.a(.href($0.slug), .p("\($0.title)"))
                    )
                })
            )
        )
    }
}
