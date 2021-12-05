//
//  File.swift
//  
//
//  Created by Kevin on 12/4/21.
//

import Foundation

// Need a concrete type for the task group
private struct IndexedItem<T> {
    let index: Int
    let item: T
}

public extension Sequence {
    func collect() -> [Element] {
        reduce(into: []) { $0.append($1) }
    }
}

public extension Sequence {
    func mapAsync<T>(task: @escaping (Element) async throws -> T) async rethrows -> [T] {
        try await withThrowingTaskGroup(of: IndexedItem<T>.self, returning: [T].self) { group in
            for (index, item) in enumerated() {
                group.addTask {
                    IndexedItem(index: index, item: try await task(item))
                }
            }
            return try await group.collect().sorted { $0.index < $1.index } .map(\.item)
        }
    }
}
