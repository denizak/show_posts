//
//  LoginViewModelTests.swift
//  dbTests
//
//  Created by deni zakya on 09/09/23.
//

import XCTest
import Combine
@testable import db

final class LoginViewModelTests: XCTestCase {

    func testLogin() {
        var actualSaveUserId = -1
        let sut = LoginViewModel(saveUserId: { actualSaveUserId = $0 })

        var loginSuccessCalled = false
        let cancelable = sut.loginSuccess.sink(receiveValue: { loginSuccessCalled = true })
        defer { cancelable.cancel() }

        sut.login(userId: "100")

        XCTAssertTrue(loginSuccessCalled)
        XCTAssertEqual(actualSaveUserId, 100)
    }

    func testLoginError() {
        var actualSaveUserId = -1
        let sut = LoginViewModel(saveUserId: { actualSaveUserId = $0 })

        var loginErrorValue = ""
        let cancelable = sut.loginError.sink(receiveValue: { loginErrorValue = $0 })
        defer { cancelable.cancel() }

        sut.login(userId: "not number")

        XCTAssertEqual(loginErrorValue, "Unable to parse user id")
        XCTAssertEqual(actualSaveUserId, -1)
    }

}
