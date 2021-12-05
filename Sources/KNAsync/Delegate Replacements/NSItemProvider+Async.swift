//
//  NSItemProvider+Async.swift
//  
//
//  Created by Kevin on 12/4/21.
//

import Foundation

extension NSItemProvider {
    func loadObject<T: _ObjectiveCBridgeable>(ofClass cls: T.Type) async throws -> T where T._ObjectiveCType : NSItemProviderReading {
        try await withCheckedThrowingContinuation { continuation in
            _ = loadObject(ofClass: cls) { (result: T?, error: Error?) in
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
}

