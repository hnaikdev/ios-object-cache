//
//  AsyncCallBackObjectCacheServiceTests.swift
//  SwiftObjectCache
//
//  Created by Hiral Naik on 8/20/25.
//

import Testing
@testable import SwiftObjectCache

@Test("Store and retrieve object from cache")
func asyncCallbackStoreAndRetrieve() async {
    let service = AsyncCallBackObjectCacheService(cacheSize: .large)
    let model = try! TestModel(id: "1", name: "Alice")
    
    let result = await withCheckedContinuation { continuation in
        service.store(model) { error in
            continuation.resume(returning: error)
        }
    }
    
    let (object, retrieveError) = await withCheckedContinuation { continuation in
        service.retrieve("1") { (object: TestModel?, error) in
            continuation.resume(returning: (object, error))
        }
    }
    
    #expect(result == nil)
    #expect(object?.id == "1")
    #expect(object?.name == "Alice")
    #expect(retrieveError == nil)
}

@Test("Update and retrieve object from cache")
func asyncCallbackUpdateAndRetrieve() async throws {
    let cache = AsyncCallBackObjectCacheService(cacheSize: .large)
    let model = try! TestModel(id: "1", name: "Alice")
    
    _ = await withCheckedContinuation { continuation in
        cache.store(model) { error in
            continuation.resume(returning: error)
        }
    }
    
    var object = await withCheckedContinuation { continuation in
        cache.retrieve("1") { (object: TestModel?, error) in
            continuation.resume(returning: object)
        }
    }
    
    object?.name = "Bob"
    
    _ = await withCheckedContinuation { continuation in
        cache.store(object!) { error in
            continuation.resume(returning: error)
        }
    }
   
    let (updatedObject, retrieveError) = await withCheckedContinuation { continuation in
        cache.retrieve("1") { (object: TestModel?, error) in
            continuation.resume(returning: (object, error))
        }
    }
    
    #expect(updatedObject?.id == "1")
    #expect(updatedObject?.name == "Bob")
    #expect(retrieveError == nil)
}

@Test("Store and retrieve multiple objects from cache")
func asyncCallbackStoreAndRetrieveMultipleObjects() async throws {
    let cache = AsyncCallBackObjectCacheService(cacheSize: .large)
    let model = try TestModel(id: "1", name: "Alice")
    let model2 = try TestModel(id: "2", name: "Mat")

    _ = await withCheckedContinuation { continuation in
        cache.store(model) { error in
            continuation.resume(returning: error)
        }
    }
    
    _ = await withCheckedContinuation { continuation in
        cache.store(model2) { error in
            continuation.resume(returning: error)
        }
    }
    
    let objects: [TestModel] = await withCheckedContinuation { continuation in
        cache.retrieve(["1", "2"], completion: { objects, error in
            continuation.resume(returning: objects)
        })
    }

    #expect(objects.count == 2)
}

@Test("Remove object from cache")
func asyncCallbackRemoveObject() async throws {
    let cache = AsyncCallBackObjectCacheService(cacheSize: .large)
    let model = try TestModel(id: "2", name: "Bob")

    _ = await withCheckedContinuation { continuation in
        cache.store(model) { error in
            continuation.resume(returning: error)
        }
    }
    
    _ = await withCheckedContinuation { continuation in
        cache.remove(model) { error in
            continuation.resume(returning: error)
        }
    }
    
    let error = await withCheckedContinuation { continuation in
        cache.retrieve("1") { (object: TestModel?, error) in
            continuation.resume(returning: error)
        }
    }
    
    #expect(CacheError.objectNotFound == error)
}

@Test("Try to remove object from cache that doesn't exist")
func asyncCallbackRemoveNonExistObject() async throws {
    let cache = AsyncCallBackObjectCacheService(cacheSize: .large)
    let model = try TestModel(id: "2", name: "Bob")
    let model1 = try TestModel(id: "3", name: "Bob")

    _ = await withCheckedContinuation { continuation in
        cache.store(model) { error in
            continuation.resume(returning: error)
        }
    }
    
    let error = await withCheckedContinuation { continuation in
        cache.remove(model1) { error in
            continuation.resume(returning: error)
        }
    }
    
    #expect(CacheError.objectNotFound == error)
}
