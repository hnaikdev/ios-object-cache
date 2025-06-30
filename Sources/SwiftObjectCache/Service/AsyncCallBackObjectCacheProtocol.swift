//
//  AsyncCallBackObjectCacheProtocol.swift
//  SwiftObjectCache
//
//  Created by Hiral Naik on 6/30/25.
//

import Foundation

public protocol AsyncCallBackObjectCacheProtocol {

    // Remove the object from the cache
    func remove<T: ObjectCache>(
        _ object: T,
        completion: @escaping (CacheError?) -> Void
    )

    // Retrieve the object from the cache
    func retrieve<T: ObjectCache>(
        _ key: String,
        completion: @escaping (T?, CacheError?) -> Void
    )

    // Retrieve the multiple objects from the cache
    func retrieve<T: ObjectCache>(
        _ keys: [String],
        completion: @escaping ([T], CacheError?) -> Void
    )

    // Store the object in the cache
    func store<T: ObjectCache>(
        _ object: T,
        completion: @escaping (CacheError?) -> Void
    )
}
