//
//  GetPostItemTests.swift
//  dbTests
//
//  Created by deni zakya on 09/09/23.
//

import XCTest
@testable import db

final class GetPostItemTests: XCTestCase {

    func testGetPosts() async throws {
        var actualUserIdValue = -1
        let sut = GetPostItem(
            requestPostItem: { userId in
                actualUserIdValue = userId
                return [.init(id: 200, userId: 111, title: "any-title", body: "any-body", isFavorite: false)]
            },
            getFavoritePostItem: { userId in [.init(id: 200, userId: userId, title: "any-title", body: "any-body", isFavorite: true)] },
            getUserId: { 1000 })

        let postItems = try await sut.getPosts()

        XCTAssertEqual(actualUserIdValue, 1000)
        XCTAssertEqual(postItems.count, 1)
        let item = try XCTUnwrap(postItems.first)
        XCTAssertEqual(item.id, 200)
        XCTAssertTrue(item.isFavorite)
    }

    func testGetPosts_noFavoriteExists() async throws {
        var actualUserIdValue = -1
        let sut = GetPostItem(
            requestPostItem: { userId in
                actualUserIdValue = userId
                return [.init(id: 200, userId: 111, title: "any-title", body: "any-body", isFavorite: false)]
            },
            getFavoritePostItem: { _ in [] },
            getUserId: { 1000 })

        let postItems = try await sut.getPosts()

        XCTAssertEqual(actualUserIdValue, 1000)
        XCTAssertEqual(postItems.count, 1)
        let item = try XCTUnwrap(postItems.first)
        XCTAssertEqual(item.id, 200)
        XCTAssertFalse(item.isFavorite)
    }

    func testGetPosts_userNil() async throws {
        var actualUserIdValue = -1
        let sut = GetPostItem(
            requestPostItem: { userId in
                actualUserIdValue = userId
                return [.init(id: 200, userId: 111, title: "any-title", body: "any-body", isFavorite: false)]
            },
            getFavoritePostItem: { _ in [] },
            getUserId: { nil })

        let postItems = try await sut.getPosts()

        XCTAssertEqual(actualUserIdValue, -1)
        XCTAssertTrue(postItems.isEmpty)
    }
}
