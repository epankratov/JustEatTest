//
//  WebResource.swift
//  JustEatTest
//
//  Created by Eugene Pankratov on 19.05.2018.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

/**
 *  A struct describing a HTTP resource. This also includes the HTTP method used and a function to parse the result.
 The generic parameter describes the return type of the parsed object
 */
public struct WebResource<A> {

    /// The path of the resource
    let path: String?

    /// The HTTP Method used to interact with the resource
    let method: HTTPMethod

    ///  Additional URL parameters
    var parameters: [String: String]?

    ///  Additional BODY parameters
    var bodyParameters: [String: Any]?

    /// Headers
    var headers: [String: String]?

    /// Because this parsing might fail, the result is an optional.
    let parse: (Data?) -> A?

    public init(path: String?, method: HTTPMethod, params: [String: String]?, bodyParams: [String: Any]?, headers: [String: String]?, parse: @escaping (Data?) -> A?)
    {
        self.path = path
        self.method = method
        self.parameters = params
        self.bodyParameters = bodyParams
        self.headers = headers
        self.parse = parse
    }

    public init(path: String?, method: HTTPMethod, params: [String : String]?, parse: @escaping (Data?) -> A?)
    {
        self.init(path: path, method: method, params: params, bodyParams: nil, headers: nil, parse: parse)
    }

    public init(path: String?, method: HTTPMethod, parse: @escaping (Data?) -> A?) {
        self.init(path: path, method: method, params: nil, parse: parse)
    }

}
