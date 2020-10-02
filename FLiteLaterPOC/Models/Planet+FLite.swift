//
//  Planet+FLite.swift
//  FLiteLaterPOC
//
//  Created by Zach Eriksen on 10/2/20.
//

import Foundation
import FluentSQLiteDriver

final class Planet: Model {
    // Name of the table or collection.
    static let schema = "planets"

    // Unique identifier for this Planet.
    @ID(key: .id)
    var id: UUID?

    // The Planet's name.
    @Field(key: "name")
    var name: String

    // Creates a new, empty Planet.
    init() { }

    // Creates a new Planet with all properties set.
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

extension Planet: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Planet.schema)
            .id()
            .field("name", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Planet.schema).delete()
    }
}
