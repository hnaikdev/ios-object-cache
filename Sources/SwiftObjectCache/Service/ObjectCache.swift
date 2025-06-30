//
//  ObjectCache.swift
//  SwiftObjectCache
//
//  Created by Hiral Naik on 6/30/25.
//

import Foundation

public protocol ObjectCache: Sendable {
    init?(data: Data)
    func key() -> String
    func data() -> Data
}

class ObjectCacheBox {
    var data: Data?

    init(data: Data? = nil) {
        self.data = data
    }
}
