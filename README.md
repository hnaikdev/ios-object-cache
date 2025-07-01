# ios-object-cache
SwiftObjectCache is a lightweight and efficient generic caching library for Swift to cache any object.

## 🚀 Features

- ✅ Generic caching with support for any `Codable` object
- ✅ Type-safe key management
- ✅ Memory-aware caching with `NSCache`
- ✅ Simple protocol-based design
- ✅ Supports async/await and completion handlers
- ✅ Compitable with Dependency Injection(DI)
- ✅ Support different Sizes: small, medium, large

## 📦 Installation

Just drag and drop the files into your project:

- `ObjectCache.swift`
- `ObjectCacheService.swift`
- `ObjectCacheBox.swift`
- `AsyncObjectCacheProtocol.swift` for async/await
-  `AsyncCallBackObjectCacheProtocol.swift`  for callback implementation
- Any implementation of `ObjectCacheProtocol`

## 🧩 Protocol

```swift
public protocol ObjectCache {
    init?(data: Data)
    func key() -> String
    func data() -> Data
}
```

## 🧩 Usage

1. Conform Your Model
   
```swift
struct User: Codable, ObjectCache {
    let id: String
    let name: String

    func key() -> String { id }

    func data() -> Data {
        try! JSONEncoder().encode(self)
    }

    init?(data: Data) {
        guard let decoded = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        self = decoded
    }
}
```

2. Use ObjectCacheService

```swift
let cacheService = ObjectCacheService()

// Store
let user = User(id: "123", name: "Hiral")
try cacheService.store(user)

// Retrieve
let cachedUser: User? = try cacheService.retrieve("123")

// Remove
try cacheService.remove(user)
```

## Composite Key
ObjectCacheService uses a composite key internally:

```swift
"\(Type)-\(user.key())"
```
This ensures object types do not collide in the cache.

## Customization

### Cache Size Limit

```swift
enum CacheSize {
    case small, medium, large

    var maxDataSize: Int {
        switch self {
        case .small: return 5 * 1024 * 1024
        case .medium: return 20 * 1024 * 1024
        case .large: return 100 * 1024 * 1024
        }
    }
}

let cacheService = ObjectCacheService(cacheSize: .medium)
```

### Async/Await Version
An async-compatible version AsyncObjectCacheService is available and supports:

```swift
await cacheService.store(user)
let user = try await cacheService.retrieve("123")
```

## Contributions
Contributions and improvements are welcome. Feel free to fork and submit PRs or open issues.
