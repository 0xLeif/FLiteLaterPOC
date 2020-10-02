//
//  PlanetDetailView.swift
//  FLiteLaterPOC
//
//  Created by Zach Eriksen on 10/2/20.
//

import SwiftUI

struct PlanetDetailView: View {
    @EnvironmentObject var store: FLiteStore
    
    @State var planet: Planet
    
    var body: some View {
        TextField("Planet Name", text: $planet.name, onCommit: {
            store.persist.update(model: planet)
        })
    }
}

struct PlanetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlanetDetailView(planet: Planet(name: "Earth"))
    }
}
