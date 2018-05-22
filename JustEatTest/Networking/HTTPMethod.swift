//
//  HTTPMethods.swift
//  JustEatTest
//
//  Created by Eugene Pankratov on 19.05.2018.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

/**
 An Enum describing the 4 basic HTTP methods. Post and put can have a body.
 - GET:    HTTP method GET
 - POST:   HTTP method POST
 - PUT:    HTTP method PUT
 - DELETE: HTTP method DELETE
 */
public enum HTTPMethod {
    /// HTTP method GET
    case GET

    /// HTTP method POST. The parameter is the data to be sent to the server
    case POST(Data?)

    /// HTTP method PUT. The parameter is the data to be sent to the server
    case PUT(Data?)

    /// HTTP method DELETE
    case DELETE

    /// - returns: A string representation of the Method
    public func requestMethod() -> String {
        switch self {
        case .GET:
            return "GET"
        case .POST( _):
            return "POST"
        case .PUT( _):
            return "PUT"
        case .DELETE:
            return "DELETE"
        }
    }

    /// - returns: The body of the HTTP method. Only avaiable for Put and Post. Nil otherwise
    public func requestBody() -> Data? {
        switch self {
        case .POST(let body):
            return body
        case .PUT(let body):
            return body
        default:
            return nil
        }
    }
}
