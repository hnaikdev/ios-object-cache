//
//  TestModel.swift
//  SwiftObjectCache
//
//  Created by Hiral Naik on 8/20/25.
//

import Testing
import Foundation
@testable import SwiftObjectCache

struct TestModel: Codable, ObjectCache {
    
    let id: String
    var name: String
    
    init(id: String, name: String) throws {
        self.id = id
        self.name = name
    }
    
    func key() -> String {
        id
    }
    
    func data() -> Data {
        try! JSONEncoder().encode(self)
    }
    
    init?(data: Data) {
        guard let decoded = try? JSONDecoder().decode(TestModel.self, from: data) else { return nil }
        self = decoded
    }
}
