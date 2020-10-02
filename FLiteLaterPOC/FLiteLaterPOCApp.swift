//
//  FLiteLaterPOCApp.swift
//  FLiteLaterPOC
//
//  Created by Zach Eriksen on 10/2/20.
//

import SwiftUI
import FLite

class FLiteStore: ObservableObject {
    public var memory = FLite(loggerLabel: "memory-FLITE")
    public var persist = FLite(configuration: .file("\(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path ?? "")/default.sqlite"), loggerLabel: "persisted-FLITE")
}

@main
struct FLiteLaterPOCApp: App {
    let store = FLiteStore()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(store)
            }
            .onAppear {
                print("Starting to prepare...")
                try? store.persist.prepare(migration: Planet.self).wait()
                print("Prepared Migrations")
            }
        }
        
    }
}
