//
//  APIService.swift
//  Example
//
//  Created by Hiral Naik on 7/1/25.
//

import Foundation
import SwiftObjectCache

protocol APIServiceProtocol {
    func fetchData() async throws -> [User]
    func readFromCache(for keys: [Int]) async throws -> [User]
    func deleteFromCache(for key: Int) async throws
    func fetchData(completion: @escaping ([User], APIServiceError?) -> Void)
}

class APIService: APIServiceProtocol {
    
    let networkService: NetworkClientProtocol
    let cacheService: AsyncObjectCacheProtocol
    
    init(networkService: NetworkClientProtocol, cacheService: AsyncObjectCacheProtocol) {
        self.networkService = networkService
        self.cacheService = cacheService
    }
    
    func fetchData() async throws -> [User] {
        do {
            let urlString = "https://fake-json-api.mock.beeceptor.com/users"
            let url = URL(string: urlString)
            let request = URLRequest(url: url!)
            
            let result = try await networkService.fetch(request, type: [User].self)
            
            for user in result {
                try await cacheService.store(user)
            }
            
            return result
        } catch {
            throw error
        }
    }
    
    func readFromCache(for keys: [Int]) async throws -> [User] {
        do {
            let stringKeys = keys.map { $0.description }
            return try await cacheService.retrieve(stringKeys)
        } catch {
            throw error
        }
    }
    
    func deleteFromCache(for key: Int) async throws {
        do {
            let object: User = try await cacheService.retrieve(key.description)
            return try await cacheService.remove(object)
        } catch {
            throw error
        }
    }
    
    func fetchData(completion: @escaping ([User], APIServiceError?) -> Void) {
        let urlString = "https://fake-json-api.mock.beeceptor.com/users"
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        
        networkService.fetch(request, type: [User].self) { users, error in
            guard error == nil else {
                completion([], error)
                return
            }
            completion(users ?? [], nil)
        }
    }
}
