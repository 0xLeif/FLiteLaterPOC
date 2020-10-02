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

## Later Usage
```swift
.navigationBarItems(
    leading: Button("Delete All") {
        Later.whenAllSucceed(
            items.map {
                store.persist.delete(model: $0)
            }
        )
        .flatMap { _ in store.persist.all(model: Planet.self) }
        .whenSuccess { items = $0 }
    },
    trailing: Button("100") {
        Later.whenAllSucceed(
            (0 ... 99).map { _ in
                store.persist.add(model: Planet.random)
            }
        )
        .flatMap { _ in store.persist.all(model: Planet.self) }
        .whenSuccess { items = $0 }
    }
)
```

![Example Video](.media/example.gif)
