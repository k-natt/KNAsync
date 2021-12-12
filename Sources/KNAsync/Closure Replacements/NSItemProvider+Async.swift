//
//  NSItemProvider+Async.swift
//  
//
//  Created by Kevin on 12/4/21.
//

import Foundation
import UniformTypeIdentifiers

public extension NSItemProvider {
    func loadObject<T: _ObjectiveCBridgeable>(ofClass cls: T.Type) async throws -> T where T._ObjectiveCType : NSItemProviderReading {
        try await asyncCallback("NSItemProvider.loadObject") {
            _ = self.loadObject(ofClass: cls, completionHandler: $0)
        }
    }

    func loadObject<T: NSItemProviderReading>(ofClass cls: T.Type) async throws -> T {
        let untypedResult = try await asyncCallback("NSItemProvider.loadObject") {
            self.loadObject(ofClass: cls, completionHandler: $0)
        }
        guard let typedResult = untypedResult as? T else {
            throw KNAsyncError.UnderlyingApiInvalidBehavior("NSItemProvider.loadObject returned object of incorrect class: \(type(of: untypedResult)) is not compatible with \(T.self)")
        }
        return typedResult
    }

    /// Copies item to a temporary file which the user should move to a permanent location.
    @available(iOS 14.0, *)
    func loadFileRepresentation(forType type: UTType) async throws -> URL {
        try await asyncCallback("NSItemProvider.loadFileRepresentation") {
            self.loadFileRepresentation(forTypeIdentifier: type.identifier, completionHandler: $0)
        }
    }

    @available(iOS 14.0, *)
    func loadDataRepresentation(forType type: UTType) async throws -> Data {
        try await asyncCallback("NSItemProvider.loadDataRepresentation") {
            self.loadDataRepresentation(forTypeIdentifier: type.identifier, completionHandler: $0)
        }
    }
}

