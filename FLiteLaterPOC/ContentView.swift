//
//  ContentView.swift
//  FLiteLaterPOC
//
//  Created by Zach Eriksen on 10/2/20.
//

import SwiftUI
import FLite
import NIO
import Later

struct ContentView: View {
    @EnvironmentObject var store: FLiteStore
    
    @State private var items: [Planet] = [] 
    
    var body: some View {
        List {
            ForEach(items, id: \.id) { item in
                VStack {
                    NavigationLink(item.name, destination: PlanetDetailView(planet: item))
                }
            }
            .onDelete(perform: { indexSet in
                indexSet.forEach { index in
                    store.persist.delete(model: items[index])
                        .whenSuccess { items.remove(at: index) }
                }
            })
        }
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
                        store.persist.add(model: Planet(name: "New Planet \(Int.random(in: 0 ... 9))\(Int.random(in: 0 ... 9))\(Int.random(in: 0 ... 9))\(Int.random(in: 0 ... 9))"))
                    }
                )
                .flatMap { _ in store.persist.all(model: Planet.self) }
                .whenSuccess { items = $0 }
            }
        )
        .navigationTitle("FLite Later POC")
        .onAppear {
            store.persist.all(model: Planet.self)
                .whenSuccess {
                    items = $0
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
