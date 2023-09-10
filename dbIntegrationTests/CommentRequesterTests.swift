//
//  CommentRequesterTests.swift
//  dbIntegrationTests
//
//  Created by Deni Zakya on 10/09/23.
//

import XCTest
@testable import db

final class CommentRequesterTests: XCTestCase {

    func testRequest() async throws {
        let sut = CommentRequester()

        let responseItems = try await sut.request(postId: 1)

        XCTAssertGreaterThan(responseItems.count, 0)
        let firstItem = try XCTUnwrap(responseItems.first)
        XCTAssertEqual(firstItem.id, 1)
        XCTAssertEqual(firstItem.postId, 1)
        XCTAssertFalse(firstItem.name.isEmpty)
        XCTAssertFalse(firstItem.email.isEmpty)
        XCTAssertFalse(firstItem.body.isEmpty)
    }

}
