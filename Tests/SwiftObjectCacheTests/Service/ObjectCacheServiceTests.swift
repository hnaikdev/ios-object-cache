//
//  ObjectCacheServiceTests.swift
//  SwiftObjectCache
//
//  Created by Hiral Naik on 8/20/25.
//

import Testing
@testable import SwiftObjectCache

@Test("Store and retrieve object from cache")
func storeAndRetrieve() async throws {
    do {
        let cache = ObjectCacheService(cacheSize: .large)
        let model = try TestModel(id: "1", name: "Alice")

        try cache.store(model)
        let retrieved: TestModel? = try cache.retrieve("1")

        #expect(retrieved != nil)
        #expect(retrieved?.name == "Alice")
    } catch {
        #expect(Bool(false))
    }
}

@Test("Update and retrieve object from cache")
func updateAndRetrieve() async throws {
    do {
        let cache = ObjectCacheService(cacheSize: .large)
        let model = try TestModel(id: "1", name: "Alice")

        try cache.store(model)
        var retrieved: TestModel = try cache.retrieve("1")
        retrieved.name = "Bob"
        try cache.store(retrieved)
        
        let updatedObj: TestModel? = try cache.retrieve("1")
       
        #expect(updatedObj != nil)
        #expect(updatedObj?.name == "Bob")
    } catch {
        #expect(Bool(false))
    }
}

@Test("Store and retrieve multiple objects from cache")
func storeAndRetrieveMultipleObjects() async throws {
    do {
        let cache = ObjectCacheService(cacheSize: .large)
        let model = try TestModel(id: "1", name: "Alice")
        let model2 = try TestModel(id: "2", name: "Mat")

        try cache.store(model)
        try cache.store(model2)
        let retrieved: [TestModel] = try cache.retrieve(["1", "2"])

        #expect(retrieved.count == 2)
    } catch {
        #expect(Bool(false))
    }
}

@Test("Remove object from cache")
func removeObject() async throws {
    do {
        let cache = ObjectCacheService(cacheSize: .large)
        let model = try TestModel(id: "2", name: "Bob")

        try cache.store(model)
        try cache.remove(model)
        let _: TestModel? = try cache.retrieve("2")
    } catch {
        #expect(CacheError.objectNotFound == error as! CacheError)
    }
}

@Test("Try to remove object from cache that doesn't exist")
func removeNonExistObject() async throws {
    do {
        let cache = ObjectCacheService(cacheSize: .large)
        let model = try TestModel(id: "2", name: "Bob")
        let model1 = try TestModel(id: "3", name: "Bob")

        try cache.store(model)
        try cache.remove(model1)
    } catch {
        #expect(CacheError.objectNotFound == error as! CacheError)
    }
}

@Test("Retrieve non-existent object returns nil")
func retrieveNonexistent() async throws {
    do {
        let cache = ObjectCacheService(cacheSize: .large)
        let _: TestModel? = try cache.retrieve("404")
    } catch {
        #expect(CacheError.objectNotFound == error as! CacheError)
    }
}
