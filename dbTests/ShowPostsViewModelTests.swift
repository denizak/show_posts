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

        let sut = ShowPostsViewModel(getPosts: { userId in
            defer { expectLoad.fulfill() }
            actualUserId = userId
            return [PostItem(id: 1, title: "any-title", body: "any-body")]
        }, getUserId: { 100 })
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
        let sut = ShowPostsViewModel(getPosts: { userId in
            actualUserId = userId
            return []
        }, getUserId: { nil })
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
        let sut = ShowPostsViewModel(getPosts: { userId in
            throw ViewModelError.testError
        }, getUserId: { 1 })
        let cancellable = sut.showErrorView.sink(receiveValue: { _ in
            showErrorViewCalled = true
            expectLoad.fulfill()
        })
        defer { cancellable.cancel() }

        sut.viewAppear()
        wait(for: [expectLoad], timeout: 1)

        XCTAssertTrue(showErrorViewCalled)
    }
}

enum ViewModelError: Error {
    case testError
}
