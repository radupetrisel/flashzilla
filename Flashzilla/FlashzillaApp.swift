//
//  FlashzillaApp.swift
//  Flashzilla
//
//  Created by Radu Petrisel on 26.07.2023.
//

import SwiftUI

@main
struct FlashzillaApp: App {
    private let storageManager = StorageManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(storageManager)
        }
    }
}
