//
//  ExampleApp.swift
//  Example
//
//  Created by Hiral Naik on 7/1/25.
//

import SwiftUI
import SwiftObjectCache

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            let cacheService = AsyncObjectCacheService(cacheSize: .small)
            let service = APIService(networkService: NetworkClient(), cacheService: cacheService)
            let viewModel = UserViewModel(service: service)
            ContentView(viewModel: viewModel)
        }
    }
}
