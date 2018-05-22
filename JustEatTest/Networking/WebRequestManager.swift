//
//  WebRequestManager.swift
//  JustEatTest
//
//  Created by Eugene Pankratov on 19.05.2018.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

public class WebRequestManager {
    private let allowedStatusCodesForEmptyResponse = [205, 204]

    private let sessionConfig: URLSessionConfiguration
    private var session: URLSession?
    private var tasks = [Int: WebTask]()
    private let requestBuilder: WebRequestBuilder
    private let acceptableStatusCodes: Range<Int>

    public var numberOfActiveTasks: Int {
        return tasks.count
    }

    //MARK: Lifecycle

    /**
     - parameter config:                NSURLSessionConfiguration used in the requests default: nil
     - parameter acceptableStatusCodes: A range of HTTP Status codes that is accepted as valid response default: 200..<300
     */
    public init(config: URLSessionConfiguration? = nil, acceptableStatusCodes: Range<Int> = 200..<300) {
        sessionConfig = config ?? URLSessionConfiguration.default
        self.requestBuilder = WebRequestBuilder()
        self.acceptableStatusCodes = acceptableStatusCodes
    }

    deinit {
        cancelAll()
    }

    /**
     Starts a request to a specified resource

     - parameter baseURL:       Base URL of the request
     - parameter resource:      The requested Resource
     - parameter modifyRequest: A block to modify the request just before it is sent
     - parameter completion:    Completion block with Result (either success or error)

     - returns: A Task instance that can be used to resume, cancel or suspend the request
     */
    open func request<A>(_ baseURL: URL, resource: WebResource<A>, completion: @escaping (WebResult<A>) -> Void) -> WebTask
    {
        let task = WebTask()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
            guard
                let urlRequest = self.requestBuilder.createURLRequestFromResource(baseURL, resource: resource),
                task.state != URLSessionTask.State.canceling && task.state != URLSessionTask.State.completed
                else {
                    return
            }
            let request = WebRequest(resource: resource, completion: completion)

            task.sessionTask = self.urlSession().dataTask(with: urlRequest, completionHandler: { [weak self] data, response, error in
                let error = error as NSError?
                self?.completeTask(task, data: data, request: request, response: response, error: error)
            })

            self.tasks[task.sessionTask!.taskIdentifier] = task

            if task.state == URLSessionTask.State.running {
                task.resume()
            }
        }

        return task
    }

    fileprivate func completeTask<A>(_ task: WebTask, data: Data?, request: WebRequest<A>, response: URLResponse?, error: NSError?) {
        self.tasks.removeValue(forKey: task.sessionTask!.taskIdentifier)

        let httpResponse = response as! HTTPURLResponse?
        let statusCode = httpResponse?.statusCode ?? 0

        // Error Present
        if let error = error  {
            let webError = WebError(code: error.code, responseHeaders: httpResponse?.allHeaderFields as? [String: AnyObject], responseData: data)
            request.completion(.resultError(webError, request))
        } else if !(acceptableStatusCodes ~= statusCode) { // ~= meaning "Range contains"
            let webError = WebError(code: statusCode, responseHeaders: httpResponse?.allHeaderFields as? [String: AnyObject], responseData: data)
            request.completion(.resultError(webError, request))
        } else {
            // parse data
            guard let parsedData = request.resource.parse(data) else {
                // check if empty repsonse allowed
                if allowedStatusCodesForEmptyResponse.contains(statusCode) {
                    request.completion(.resultSuccess(nil, request, statusCode))
                } else {
                    let webError = WebError(code: 1, responseHeaders: httpResponse?.allHeaderFields as? [String: AnyObject], responseData: data)
                    request.completion(.resultError(webError, request))
                }
                return
            }
            request.completion(.resultSuccess(parsedData, request, statusCode))
        }
    }

    /**
     Executes a Request

     - parameter baseURL:  Base URL of the request
     - parameter aRequest: The request to be executed

     - returns: A Task instance that can be used to resume, cancel or suspend the request
     */
    open func request<A>(_ baseURL: URL, aRequest: WebRequest<A>) -> WebTask {
        return request(baseURL, resource: aRequest.resource, completion: aRequest.completion)
    }

    fileprivate func urlSession() -> URLSession {
        session = session ?? URLSession(configuration: sessionConfig)
        return session ?? URLSession(configuration: sessionConfig)
    }

    /**
     Cancels all current Tasks
     */
    open func cancelAll() {
        if let session = session {
            session.invalidateAndCancel()
            self.session = nil
            self.tasks.removeAll(keepingCapacity: false)
        }
    }
}
