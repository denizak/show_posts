//
//  UserIdStorage.swift
//  db
//
//  Created by deni zakya on 09/09/23.
//

import Foundation

final class UserIdStorage {
    static let shared = UserIdStorage()
    private var userId: Int?

    func update(_ id: Int) {
        userId = id
    }

    func get() -> Int? {
        userId
    }
}
