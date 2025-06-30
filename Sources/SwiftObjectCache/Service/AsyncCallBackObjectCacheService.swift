//
//  AsyncCallBackObjectCacheService.swift
//  SwiftObjectCache
//
//  Created by Hiral Naik on 6/30/25.
//

import Foundation

public class AsyncCallBackObjectCacheService: AsyncCallBackObjectCacheProtocol {

    private let cacheService: ObjectCacheProtocol

    public init(cacheSize: CacheSize = .small) {
        self.cacheService = ObjectCacheService(cacheSize: cacheSize)
    }

    public func remove<T: ObjectCache>(
        _ object: T,
        completion: @escaping (CacheError?) -> Void
    ) {
        DispatchQueue.global().async { [weak self] in
            guard let self else {
                DispatchQueue.main.async {
                    completion(.removeFailed)
                }
                return
            }

            let result: CacheError?
            do {
                try self.cacheService.remove(object)
                result = nil

            } catch let error as CacheError {
                result = error
            } catch {
                result = .removeFailed
            }

            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    public func retrieve<T: ObjectCache>(
        _ key: String,
        completion: @escaping (T?, CacheError?) -> Void
    ) {
        DispatchQueue.global().async { [weak self] in
            guard let self else {
                DispatchQueue.main.async {
                    completion(nil, .retrieveFailed)
                }
                return
            }

            let result: CacheError?
            let object: T?

            do {
                object = try self.cacheService.retrieve(key)
                result = nil
            } catch let error as CacheError {
                object = nil
                result = error
            } catch {
                object = nil
                result = .retrieveFailed
            }

            DispatchQueue.main.async {
                completion(object, result)
            }
        }
    }

    public func retrieve<T: ObjectCache>(
        _ keys: [String],
        completion: @escaping ([T], CacheError?) -> Void
    ) {
        DispatchQueue.global().async { [weak self] in
            guard let self else {
                DispatchQueue.main.async {
                    completion([], .retrieveFailed)
                }
                return
            }

            let result: CacheError?
            let object: [T]

            do {
                object = try self.cacheService.retrieve(keys)
                result = nil
            } catch let error as CacheError {
                result = error
                object = []
            } catch {
                result = .retrieveFailed
                object = []
            }

            DispatchQueue.main.async {
                completion(object, result)
            }
        }
    }

    public func store<T: ObjectCache>(
        _ object: T,
        completion: @escaping (CacheError?) -> Void
    ) {
        DispatchQueue.global().async { [weak self] in
            guard let self else {
                DispatchQueue.main.async {
                    completion(.storeFailed)
                }
                return
            }

            let result: CacheError?

            do {
                try self.cacheService.store(object)
                result = nil
            } catch let error as CacheError {
                result = error
            } catch {
                result = .storeFailed
            }

            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
