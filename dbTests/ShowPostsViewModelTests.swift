//
//  ShowPostsViewModelTests.swift
//  dbTests
//
//  Created by deni zakya on 08/09/23.
//

import XCTest
@testable import db

final class ShowPostsViewModelTests: XCTestCase {

    func testViewAppear() throws {
        let expectLoad = expectation(description: #function)

        var actualUserId = -1
        var actualPostItems: [PostItem] = []

        let sut = ShowPostsViewModel(
            getPosts: { userId in
                defer { expectLoad.fulfill() }
                actualUserId = userId
                return [PostItem(id: 1, userId: userId, title: "any-title", body: "any-body", isFavorite: false)]
            },
            getFavoritePosts: { _ in [] },
            getUserId: { 100 },
            toggleFavorite: { _ in })
        let cancellable = sut.items.sink(receiveValue: { value in actualPostItems = value })
        defer { cancellable.cancel() }

        sut.viewAppear()
        wait(for: [expectLoad], timeout: 1)

        XCTAssertEqual(actualPostItems.count, 1)
        let firstItem = try XCTUnwrap(actualPostItems.first)
        XCTAssertEqual(firstItem.id, 1)
        XCTAssertEqual(firstItem.title, "any-title")
        XCTAssertEqual(firstItem.body, "any-body")
        XCTAssertEqual(actualUserId, 100)
    }

    func testViewAppear_missingUserId() throws {
        let expectLoad = expectation(description: #function)

        var showLoginViewCalled = false
        var actualUserId = -1
        let sut = ShowPostsViewModel(
            getPosts: { userId in
                actualUserId = userId
                return []
            },
            getFavoritePosts: { _ in [] },
            getUserId: { nil },
            toggleFavorite: { _ in })
        let cancellable = sut.showLoginView.sink(receiveValue: { _ in
            showLoginViewCalled = true
            expectLoad.fulfill()
        })
        defer { cancellable.cancel() }

        sut.viewAppear()
        wait(for: [expectLoad], timeout: 1)

        XCTAssertEqual(actualUserId, -1)
        XCTAssertTrue(showLoginViewCalled)
    }

    func testViewAppear_getPostsError() throws {
        let expectLoad = expectation(description: #function)

        var showErrorViewCalled = false
        let sut = ShowPostsViewModel(
            getPosts: { userId in
                throw ViewModelError.testError
            },
            getFavoritePosts: { _ in [] },
            getUserId: { 1 },
            toggleFavorite: { _ in })
        let cancellable = sut.showErrorView.sink(receiveValue: { _ in
            showErrorViewCalled = true
            expectLoad.fulfill()
        })
        defer { cancellable.cancel() }

        sut.viewAppear()
        wait(for: [expectLoad], timeout: 1)

        XCTAssertTrue(showErrorViewCalled)
    }

    func testToggleFavorite() {
        let expectLoad = expectation(description: #function)
        var actualToggleFavoriteItem: PostItem?
        var actualPostItems: [PostItem] = []
        let sut = ShowPostsViewModel(
            getPosts: { userId in
                [PostItem(id: 1, userId: userId, title: "any-title", body: "any-body", isFavorite: true)]
            },
            getFavoritePosts: { _ in [] },
            getUserId: { 100 },
            toggleFavorite: { item in actualToggleFavoriteItem = item })
        let cancellable = sut.items.sink(receiveValue: { value in
            actualPostItems = value
            expectLoad.fulfill()
        })
        defer { cancellable.cancel() }

        sut.toggleFavorite(item: PostItem(id: 100, userId: 100, title: "any-title", body: "any-body", isFavorite: false))
        wait(for: [expectLoad], timeout: 1)

        XCTAssertNotNil(actualToggleFavoriteItem)
        XCTAssertFalse(actualPostItems.isEmpty)
    }

    func testToggleFilter() {
        var actualPostItems: [PostItem] = []
        let sut = ShowPostsViewModel(
            getPosts: { _ in [] },
            getFavoritePosts: { userId in [PostItem(id: 1, userId: userId, title: "any-title", body: "any-body", isFavorite: true)] },
            getUserId: { 100 },
            toggleFavorite: { _ in })
        let cancellable = sut.items.sink(receiveValue: { value in actualPostItems = value })
        defer { cancellable.cancel() }

        sut.toggleFilter(filter: .favorite)

        XCTAssertFalse(actualPostItems.isEmpty)
    }

    func testToggleFilter_whenUserIdNil() {
        var showLoginViewCalled = false
        let sut = ShowPostsViewModel(
            getPosts: { _ in [] },
            getFavoritePosts: { userId in [PostItem(id: 1, userId: userId, title: "any-title", body: "any-body", isFavorite: true)] },
            getUserId: { nil },
            toggleFavorite: { _ in })
        let cancellable = sut.showLoginView.sink(receiveValue: { showLoginViewCalled = true })
        defer { cancellable.cancel() }

        sut.toggleFilter(filter: .favorite)

        XCTAssertTrue(showLoginViewCalled)
    }
}

enum ViewModelError: Error {
    case testError
}
