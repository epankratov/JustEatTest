//
//  WebError.swift
//  JustEatTest
//
//  Created by Eugene Pankratov on 19.05.2018.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

/// Describe errors which may occur on requests
public struct WebError: Error {
    /// The error code. In case of a HTTP error it corresponds to the HTTP status code.
    public let code: Int

    /// The response headers sent back by the server
    public let responseHeaders: [String : Any]?

    /// If there was a raw server response you can access it here
    public let responseData: Data?
}
