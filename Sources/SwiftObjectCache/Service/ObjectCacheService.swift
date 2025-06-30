//
//  ObjectCacheService.swift
//  SwiftObjectCache
//
//  Created by Hiral Naik on 6/30/25.
//

import Foundation

class ObjectCacheService: ObjectCacheProtocol {

    private let cache: NSCache<NSString, ObjectCacheBox>

    init(cacheSize: CacheSize = .small) {
        self.cache = NSCache<NSString, ObjectCacheBox>()
        self.cache.totalCostLimit = cacheSize.maxDataSize
    }

    func remove<T: ObjectCache>(_ object: T) throws {
        let key = compositeKey(object)

        guard cache.object(forKey: key) != nil else {
            throw CacheError.objectNotFound
        }
        cache.removeObject(forKey: key)
    }

    func retrieve<T: ObjectCache>(_ key: String) throws -> T {
        let key = compositeKey(type: T.self, key: key)
        guard let cachedObject = cache.object(forKey: key),
            let data = cachedObject.data, let object = T(data: data)
        else {
            throw CacheError.objectNotFound
        }
        return object
    }

    func retrieve<T: ObjectCache>(_ keys: [String]) throws -> [T] {
        let objects: [T] = keys.compactMap { try! self.retrieve($0) }
        return objects
    }

    func store<T: ObjectCache>(_ object: T) throws {
        let key = compositeKey(object)
        let data = object.data()
        if let cachedObject = cache.object(forKey: key) {
            cachedObject.data = data
            cache.setObject(cachedObject, forKey: key)
        } else {
            let object = ObjectCacheBox(data: data)
            cache.setObject(object, forKey: key)
        }
    }

    func compositeKey<T: ObjectCache>(_ object: T) -> NSString {
        return compositeKey(type: T.self, key: object.key())
    }

    func compositeKey<T: ObjectCache>(type: T.Type, key: String) -> NSString {
        return "\(type)-\(key)" as NSString
    }
}
