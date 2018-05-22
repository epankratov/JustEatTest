//
//  WebRequestBuilder.swift
//  JustEatTest
//
//  Created by Eugene Pankratov on 19.05.2018.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

class WebRequestBuilder {

    public init() { }

    public func createURLRequestFromResource<A>(_ baseURL: URL, resource: WebResource<A>) -> URLRequest?
    {
        let baseComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)

        if let components = baseComponents {
            var urlComponents = components
            // Add leading / if path is missing it
            if let path = resource.path {
                if !path.hasPrefix("/") {
                    urlComponents.path = "/\(path)"
                }
            } else {
                urlComponents.path = ""
            }

            // Parse and construct parameters
            if let params = resource.parameters  {
                let queryItems: [URLQueryItem]? = params.compactMap({ (item) -> URLQueryItem in
                    let queryItem = URLQueryItem(name: item.key, value: item.value)
                    return queryItem
                })
                urlComponents.queryItems = queryItems
            }
            // Construct the URL
            let urlRequest = NSMutableURLRequest(url: urlComponents.url!)
            if let headers = resource.headers {
                for header in headers {
                    urlRequest.setValue(header.1, forHTTPHeaderField: header.0)
                }
            }

            urlRequest.httpMethod = resource.method.requestMethod()
            if let body = resource.method.requestBody() {
                let postData = body as Data
                let postLength = postData.count.description
                urlRequest.addValue(postLength, forHTTPHeaderField: "Content-Length")
                urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                urlRequest.httpBody = postData
            }

            return urlRequest.copy() as? URLRequest
        }

        return nil
    }

    private func addParameters<A>(_ urlComponents: inout URLComponents, resource: WebResource<A>)
    {
        if let parameters = resource.parameters {
            let sortedParameters = parameters.sorted { $0.0 < $1.0 }
            var query = ""
            for index in 0..<sortedParameters.count {
                let parameter = sortedParameters[index]
                query += "\(parameter.0)=\(parameter.1)"
                if index < parameters.count - 1  {
                    query += "&"
                }
            }
            urlComponents.query = query
        }
    }
}
