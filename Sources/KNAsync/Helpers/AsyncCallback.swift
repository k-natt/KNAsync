//
//  AsyncCallback.swift
//  
//
//  Created by Kevin on 12/12/21.
//

import Foundation

func asyncCallback<T>(_ context: String = "callback", start: @escaping (@escaping (T?, Error?) -> Void) -> Void) async throws -> T {
    try await withCheckedThrowingContinuation { continuation in
        start { (result, error) in
            guard let result = result else {
                guard let error = error else {
                    continuation.resume(throwing: KNAsyncError.UnderlyingApiInvalidBehavior("\(context) returned neither result nor error"))
                    return
                }
                continuation.resume(throwing: error)
                return
            }
            continuation.resume(returning: result)
        }
    }
}

class AsyncCallbackAdaptor<T> {
    private let task: Task<T, Error>

    init(context: String = "callback", start: @escaping (@escaping (T?, Error?) -> Void) -> Void) {
        self.task = Task { try await asyncCallback(context, start: start) }
    }

    func await() async throws -> T {
        try await task.value
    }
}

