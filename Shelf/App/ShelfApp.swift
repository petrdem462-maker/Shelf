//
//  ShelfApp.swift
//  Shelf
//
//  Created by Petro Demchenko on 18.11.2026.
//

import SwiftUI

@main
struct ShelfApp: App {
    private let dependencies = AppDependencies()
    
    var body: some Scene {
        WindowGroup {
            RootView(dependencies: dependencies)
        }
    }
}
