//
//  File.swift
//  
//
//  Created by Bastian Inuk Christensen on 18/03/2020.
//

import Vapor
import Plot

extension HTML: ResponseEncodable {
        public func encodeResponse(for request: Request) -> EventLoopFuture<HTML> {
        request.eventLoop.submit{self}
    }
    
    public func encodeResponse(for req: Request) -> EventLoopFuture<Response> {
        let res = Response(headers: ["content-type": "text/html; charset=utf-8"], body: .init(string: self.render()))
        return res.encodeResponse(for: req)
    }
}

//extension URLRepresentable: Codable {
//    func encode(to encoder: Encoder) throws {
//         try rawValue.encode(to: encoder)
//       }
//
//       init(from decoder: Decoder) throws {
//         rawValue = try .init(from: decoder)
//       }
//}
