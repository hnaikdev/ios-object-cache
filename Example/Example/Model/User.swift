//
//  User.swift
//  Example
//
//  Created by Hiral Naik on 7/1/25.
//

import SwiftObjectCache
import Foundation

struct User: Codable, ObjectCache {
    let id: Int?
    let name: String?
    let company: String?
    let username: String?
    let email: String?
    let address: String?
    let zip: String?
    let state: String?
    let country: String?
    let phone: String?
    let photo: String?
    
    init?(data: Data) {
        guard let user = try? JSONDecoder().decode(User.self, from: data) else { return nil }
        self = user
    }
    
    func key() -> String {
        return "\(id ?? -1)"
    }
    
    func data() -> Data {
        return try! JSONEncoder().encode(self)
    }
}
