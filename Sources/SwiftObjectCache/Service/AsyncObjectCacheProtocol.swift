//
//  AsyncObjectCacheProtocol.swift
//  SwiftObjectCache
//
//  Created by Hiral Naik on 6/30/25.
//

import Foundation

public protocol AsyncObjectCacheProtocol {

    // Remove the object from the cache
    func remove<T: ObjectCache>(_ object: T) async throws

    // Retrieve the object from the cache
    func retrieve<T: ObjectCache>(_ key: String) async throws -> T

    // Retrieve the multiple objects from the cache
    func retrieve<T: ObjectCache>(_ keys: [String]) async throws -> [T]

    // Store the object in the cache
    func store<T: ObjectCache>(_ object: T) async throws
}
