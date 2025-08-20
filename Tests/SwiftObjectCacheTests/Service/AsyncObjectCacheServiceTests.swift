//
//  AsyncObjectCacheServiceTests.swift
//  SwiftObjectCache
//
//  Created by Hiral Naik on 8/20/25.
//

import Testing
@testable import SwiftObjectCache

@Test("Store and retrieve object from cache")
func asyncStoreAndRetrieve() async throws {
    do {
        let cache = AsyncObjectCacheService(cacheSize: .large)
        let model = try TestModel(id: "1", name: "Alice")

        try await cache.store(model)
        let retrieved: TestModel? = try await cache.retrieve("1")

        #expect(retrieved != nil)
        #expect(retrieved?.name == "Alice")
    } catch {
        #expect(Bool(false))
    }
}

@Test("Update and retrieve object from cache")
func asyncUpdateAndRetrieve() async throws {
    do {
        let cache = AsyncObjectCacheService(cacheSize: .large)
        let model = try TestModel(id: "1", name: "Alice")

        try await cache.store(model)
        var retrieved: TestModel = try await cache.retrieve("1")
        retrieved.name = "Bob"
        try await cache.store(retrieved)
        
        let updatedObj: TestModel? = try await cache.retrieve("1")
       
        #expect(updatedObj != nil)
        #expect(updatedObj?.name == "Bob")
    } catch {
        #expect(Bool(false))
    }
}

@Test("Store and retrieve multiple objects from cache")
func asyncStoreAndRetrieveMultipleObjects() async throws {
    do {
        let cache = AsyncObjectCacheService(cacheSize: .large)
        let model = try TestModel(id: "1", name: "Alice")
        let model2 = try TestModel(id: "2", name: "Mat")

        try await cache.store(model)
        try await cache.store(model2)
        let retrieved: [TestModel] = try await cache.retrieve(["1", "2"])

        #expect(retrieved.count == 2)
    } catch {
        #expect(Bool(false))
    }
}

@Test("Remove object from cache")
func asyncRemoveObject() async throws {
    do {
        let cache = AsyncObjectCacheService(cacheSize: .large)
        let model = try TestModel(id: "2", name: "Bob")

        try await cache.store(model)
        try await cache.remove(model)
        let _: TestModel? = try await cache.retrieve("2")
    } catch {
        #expect(CacheError.objectNotFound == error as! CacheError)
    }
}

@Test("Try to remove object from cache that doesn't exist")
func asyncRemoveNonExistObject() async throws {
    do {
        let cache = AsyncObjectCacheService(cacheSize: .large)
        let model = try TestModel(id: "2", name: "Bob")
        let model1 = try TestModel(id: "3", name: "Bob")

        try await cache.store(model)
        try await cache.remove(model1)
    } catch {
        #expect(CacheError.objectNotFound == error as! CacheError)
    }
}

@Test("Retrieve non-existent object returns nil")
func asyncRetrieveNonexistent() async throws {
    do {
        let cache = AsyncObjectCacheService(cacheSize: .large)
        let _: TestModel? = try await cache.retrieve("404")
    } catch {
        #expect(CacheError.objectNotFound == error as! CacheError)
    }
}
