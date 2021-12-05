//
//  NSItemProvider+Async.swift
//  
//
//  Created by Kevin on 12/4/21.
//

import Foundation

public extension NSItemProvider {
    func loadObject<T: _ObjectiveCBridgeable>(ofClass cls: T.Type) async throws -> T where T._ObjectiveCType : NSItemProviderReading {
        try await withCheckedThrowingContinuation { continuation in
            _ = loadObject(ofClass: cls) { result, error in
                guard let result = result else {
                    guard let error = error else {
                        continuation.resume(throwing: KNAsyncError.UnderlyingApiInvalidBehavior("NSItemProvider.loadObject returned neither result nor error"))
                        return
                    }
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume(returning: result)
            }
        }
    }

    func loadObject<T: NSItemProviderReading>(ofClass cls: T.Type) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            _ = loadObject(ofClass: cls) { result, error in
                guard let result = result else {
                    guard let error = error else {
                        continuation.resume(throwing: KNAsyncError.UnderlyingApiInvalidBehavior("NSItemProvider.loadObject returned neither result nor error"))
                        return
                    }
                    continuation.resume(throwing: error)
                    return
                }
                guard let typedResult = result as? T else {
                    continuation.resume(throwing: KNAsyncError.UnderlyingApiInvalidBehavior("NSItemProvider.loadObject returned object of incorrect class: \(type(of: result)) is not compatible with \(T.self)"))
                    return
                }
                continuation.resume(returning: typedResult)
            }
        }
    }
}

