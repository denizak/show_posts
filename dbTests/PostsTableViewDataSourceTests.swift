//
//  PostsTableViewDataSourceTests.swift
//  dbTests
//
//  Created by deni zakya on 09/09/23.
//

import XCTest
@testable import db

final class PostsTableViewDataSourceTests: XCTestCase {

    func testNumberOfRows() {
        let sut = PostsTableViewDataSource()
        sut.items = [.init(id: 1, userId: 111, title: "", body: "", isFavorite: false)]

        let rows = sut.tableView(UITableView(frame: .zero), numberOfRowsInSection: 0)

        XCTAssertEqual(rows, 1)
    }

    func testCellForRow() throws {
        let tableView = UITableView(frame: .zero)
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
        let sut = PostsTableViewDataSource()
        sut.items = [.init(id: 1, userId: 111, title: "any-title", body: "any-body", isFavorite: false)]

        let cell = sut.tableView(tableView, cellForRowAt: .init(row: 0, section: 0)) as? PostCell

        let postCell = try XCTUnwrap(cell)
        XCTAssertEqual(postCell.titleLabelValue, "any-title")
    }
    
    func testLeak() {
        let sut = PostsTableViewDataSource()
        testMemoryLeak(sut)
    }

}
