//
//  FavoritePostPersistentTests.swift
//  dbIntegrationTests
//
//  Created by deni zakya on 09/09/23.
//

import XCTest
@testable import db

final class FavoritePostPersistentTests: XCTestCase {

    private let userId = 100
    private let sut = FavoritePostPersistent.shared
    override func tearDown() {
        do {
            try sut.cleanup()
        } catch {
            print("Unable to cleanup")
        }
    }

    func testGetAll() throws {
        let actualInitialCall = sut.getAll(userId: userId)

        try sut.togglePostItem(item: .init(id: 100, userId: userId, title: "any-title", body: "any-body", isFavorite: false))
        let afterTogglePostItemCall = sut.getAll(userId: userId)

        XCTAssertTrue(actualInitialCall.isEmpty)
        XCTAssertFalse(afterTogglePostItemCall.isEmpty)
    }

    func testTogglePostItem() throws {
        try sut.togglePostItem(item: .init(id: 100, userId: userId, title: "any-title", body: "any-body", isFavorite: false))
        try sut.togglePostItem(item: .init(id: 200, userId: userId, title: "any-title", body: "any-body", isFavorite: false))
        let newFavoriteItems = sut.getAll(userId: userId)

        try sut.togglePostItem(item: .init(id: 100, userId: userId, title: "any-title", body: "any-body", isFavorite: true))

        let afterSingleToggleFavoriteItems = sut.getAll(userId: userId)

        XCTAssertEqual(newFavoriteItems.count, 2)
        XCTAssertEqual(afterSingleToggleFavoriteItems.count, 1)
        let lastFavoriteItem = try XCTUnwrap(afterSingleToggleFavoriteItems.last)
        XCTAssertEqual(lastFavoriteItem.id, 200)
    }
}
