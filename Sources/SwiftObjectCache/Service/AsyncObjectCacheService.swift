//
//  AsyncObjectCacheService.swift
//  SwiftObjectCache
//
//  Created by Hiral Naik on 6/30/25.
//

import Foundation

public actor AsyncObjectCacheService: AsyncObjectCacheProtocol {

    private let cacheService: ObjectCacheProtocol

    public init(cacheSize: CacheSize = .small) {
        self.cacheService = ObjectCacheService(cacheSize: cacheSize)
    }

    public func remove<T: ObjectCache>(_ object: T) async throws {
        do {
            try cacheService.remove(object)
        } catch {
            throw error
        }
    }

    public func retrieve<T: ObjectCache>(_ key: String) async throws -> T {
        do {
            return try cacheService.retrieve(key)
        } catch {
            throw error
        }
    }

    public func retrieve<T: ObjectCache>(_ keys: [String]) async throws -> [T] {
        do {
            return try cacheService.retrieve(keys)
        } catch {
            throw error
        }
    }

    public func store<T: ObjectCache>(_ object: T) async throws {
        do {
            try cacheService.store(object)
        } catch {
            throw error
        }
    }
}
