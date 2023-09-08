//
//  PostRequesterTests.swift
//  dbIntegrationTests
//
//  Created by deni zakya on 08/09/23.
//

import XCTest
@testable import db

final class PostRequesterTests: XCTestCase {

    func testRequest() async throws {
        let sut = PostRequester()

        let responseItems = try await sut.request(userId: 1)

        XCTAssertGreaterThan(responseItems.count, 0)
        let firstItem = try XCTUnwrap(responseItems.first)
        XCTAssertEqual(firstItem.id, 1)
        XCTAssertEqual(firstItem.userId, 1)
        XCTAssertFalse(firstItem.title.isEmpty)
        XCTAssertFalse(firstItem.body.isEmpty)
    }
}
