//
//  FavoritePostPersistentTests.swift
//  dbIntegrationTests
//
//  Created by deni zakya on 09/09/23.
//

import XCTest
@testable import db

final class FavoritePostPersistentTests: XCTestCase {

    private let sut = FavoritePostPersistent()
    override func tearDown() {
        do {
            try sut.cleanup()
        } catch {
            print("Unable to cleanup")
        }
    }

    func testGetAll() throws {
        let actualInitialCall = sut.getAll()

        try sut.togglePostItem(item: .init(id: 100, title: "any-title", body: "any-body", isFavorite: false))
        let afterTogglePostItemCall = sut.getAll()

        XCTAssertTrue(actualInitialCall.isEmpty)
        XCTAssertFalse(afterTogglePostItemCall.isEmpty)
    }

    func testTogglePostItem() throws {
        try sut.togglePostItem(item: .init(id: 100, title: "any-title", body: "any-body", isFavorite: false))
        try sut.togglePostItem(item: .init(id: 200, title: "any-title", body: "any-body", isFavorite: false))
        let newFavoriteItems = sut.getAll()

        try sut.togglePostItem(item: .init(id: 100, title: "any-title", body: "any-body", isFavorite: true))

        let afterSingleToggleFavoriteItems = sut.getAll()

        XCTAssertEqual(newFavoriteItems.count, 2)
        XCTAssertEqual(afterSingleToggleFavoriteItems.count, 1)
        let lastFavoriteItem = try XCTUnwrap(afterSingleToggleFavoriteItems.last)
        XCTAssertEqual(lastFavoriteItem.id, 200)
    }
}
