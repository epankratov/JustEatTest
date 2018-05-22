//
//  WebResult.swift
//  JustEatTest
//
//  Created by Eugene Pankratov on 19.05.2018.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

/**
 An enum describing the result of a Request

 - Success: The request was successful
 - Error:   There was an error during the request
 */
public enum WebResult<A> {
    /**
     *  The request was successful
     *
     *  - A?            The parsed Object, if applicable
     *  - WebRequest<A> The initial request
     *  - Int?          The server response code, if applicable
     *
     */
    case resultSuccess(A?, WebRequest<A>, Int?)

    /**
     *  There was an error during the request
     *
     *  - WebError      The instance of WebError that occured
     *  - WebRequest<A> The initial request
     *
     */
    case resultError(WebError, WebRequest<A>)
}
