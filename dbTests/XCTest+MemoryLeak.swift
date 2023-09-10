//
//  XCTest+MemoryLeak.swift
//  dbTests
//
//  Created by Deni Zakya on 10/09/23.
//

import XCTest

extension XCTestCase {
    func testMemoryLeak(_ object: AnyObject) {
        addTeardownBlock { [weak object] in
            XCTAssertNil(object)
        }
    }
}
