//
//  ObjectCacheProtocol.swift
//  SwiftObjectCache
//
//  Created by Hiral Naik on 6/30/25.
//

import Foundation

public enum CacheError: Error {
    case objectNotFound
    case removeFailed
    case retrieveFailed
    case storeFailed
}

protocol ObjectCacheProtocol {

    // Remove the object from the cache
    func remove<T: ObjectCache>(_ object: T) throws

    // Retrieve the object from the cache
    func retrieve<T: ObjectCache>(_ key: String) throws -> T

    // Retrieve the multiple objects from the cache
    func retrieve<T: ObjectCache>(_ keys: [String]) throws -> [T]

    // Store the object in the cache
    func store<T: ObjectCache>(_ object: T) throws
}
