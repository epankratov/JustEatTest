//
//  WebTask.swift
//  JustEatTest
//
//  Created by Eugene Pankratov on 19.05.2018.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

/// This class encapsulates a network task as a wrapper of NSURLSessionTask. It can be resumed, suspended or cancelled.

public class WebTask {

    internal var sessionTask: URLSessionTask?
    internal var taskState: URLSessionTask.State = URLSessionTask.State.suspended

    /// - gets the state of the task
    open var state: URLSessionTask.State {
        return taskState
    }

    /**
     Resumes the task, if it is suspended.
     */
    open func resume() {
        taskState = URLSessionTask.State.running
        sessionTask?.resume()
    }

    /**
     Suspends the task.
     */
    open func suspend() {
        taskState = URLSessionTask.State.suspended
        sessionTask?.suspend()
    }

    /**
     Cancels the task.
     */
    open func cancel() {
        taskState = URLSessionTask.State.canceling
        sessionTask?.cancel()
    }

}
