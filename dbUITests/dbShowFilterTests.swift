//
//  dbShowFilterTests.swift
//  dbUITests
//
//  Created by deni zakya on 09/09/23.
//

import XCTest

final class dbShowFilterTests: XCTestCase {

    func testShowFilter() {
        let app = XCUIApplication()
        app.launch()

        let userIdText = app.textFields["userIdText"]
        if userIdText.waitForExistence(timeout: 2) {
            userIdText.typeText("1")
        }

        let loginButton = app.buttons["login"]
        if loginButton.waitForExistence(timeout: 2) {
            loginButton.tap()
        }

        let tablesQuery = app.tables
        tablesQuery.cells.firstMatch.buttons["favorite"].tap()
        let favoriteButton = tablesQuery.buttons["Favorite"]
        favoriteButton.tap()

        XCTAssertGreaterThan(tablesQuery.cells.count, 0)
    }

}
