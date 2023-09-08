//
//  LoginViewModel.swift
//  db
//
//  Created by deni zakya on 09/09/23.
//

import Combine

struct LoginViewModel {

    private let loginSuccessSubject = PassthroughSubject<Void, Never>()
    var loginSuccess: AnyPublisher<Void, Never> {
        loginSuccessSubject.eraseToAnyPublisher()
    }

    private let loginErrorSubject = PassthroughSubject<String, Never>()
    var loginError: AnyPublisher<String, Never> {
        loginErrorSubject.eraseToAnyPublisher()
    }

    private let saveUserId: (Int) -> Void
    init(saveUserId: @escaping (Int) -> Void) {
        self.saveUserId = saveUserId
    }

    func login(userId: String?) {
        if let userId = userId, let id = Int(userId) {
            saveUserId(id)
            loginSuccessSubject.send(())
        } else {
            loginErrorSubject.send("Unable to parse user id")
        }
    }
}

extension LoginViewModel {
    static func make() -> LoginViewModel {
        let storage = UserIdStorage.shared
        return .init(saveUserId: { userId in
            storage.update(userId)
        })
    }
}
