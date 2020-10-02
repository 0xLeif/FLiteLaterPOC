# [FLite](https://github.com/0xLeif/FLite) and [Later](https://github.com/0xLeif/Later) POC

## FLiteStore
```swift
class FLiteStore: ObservableObject {
    public var memory = FLite(loggerLabel: "memory-FLITE")
    public var persist = FLite(configuration: .file("\(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path ?? "")/default.sqlite"), loggerLabel: "persisted-FLITE")
}
```

## FLiteLaterPOCApp
```swift
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
```

![Example Image](.media/example.png)
