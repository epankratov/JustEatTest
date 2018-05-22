//
//  WebRequest.swift
//  JustEatTest
//
//  Created by Eugene Pankratov on 19.05.2018.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

/**
 *  Generic struct that describes an HTTP request.
 */
public struct WebRequest<A> {
    /// The requested resource
    let resource: WebResource<A>

    /// Is called when the request finishes. Can be an error or a success. In case of success the result is already parsed
    let completion: (WebResult<A>) -> Void
}
