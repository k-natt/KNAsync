//
//  File.swift
//  
//
//  Created by Kevin on 12/4/21.
//

import Foundation

extension AsyncSequence {
    func collect() async rethrows -> [Element] {
        try await reduce(into: []) { $0.append($1) }
    }
}
