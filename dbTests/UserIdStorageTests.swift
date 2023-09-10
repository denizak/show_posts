//
//  UserIdStorageTests.swift
//  dbTests
//
//  Created by deni zakya on 09/09/23.
//

import XCTest
@testable import db

final class UserIdStorageTests: XCTestCase {

    private let sut = UserIdStorage()

    override func setUp() {
        sut.update(200)
    }

    func testUpdate() {
        sut.update(1000)

        XCTAssertEqual(sut.get(), 1000)
    }

    func testGet() {
        let actualValue = sut.get()

        XCTAssertEqual(actualValue, 200)
    }

    func testLeak() {
        let sut = UserIdStorage()
        testMemoryLeak(sut)
    }
}
