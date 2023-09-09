//
//  ShowPostsViewModel.swift
//  db
//
//  Created by deni zakya on 08/09/23.
//

import Foundation
import Combine

final class ShowPostsViewModel {
    typealias UserId = Int

    private let itemsSubject = PassthroughSubject<[PostItem], Never>()
    var items: AnyPublisher<[PostItem], Never> {
        itemsSubject.eraseToAnyPublisher()
    }

    private let showErrorViewSubject = PassthroughSubject<Void, Never>()
    var showErrorView: AnyPublisher<Void, Never> {
        showErrorViewSubject.eraseToAnyPublisher()
    }

    private let showLoginViewSubject = PassthroughSubject<Void, Never>()
    var showLoginView: AnyPublisher<Void, Never> {
        showLoginViewSubject.eraseToAnyPublisher()
    }

    private let getPosts: (UserId) async throws -> [PostItem]
    private let getUserId: () -> Int?
    init(getPosts: @escaping (UserId) async throws -> [PostItem], getUserId: @escaping () -> Int?) {
        self.getPosts = getPosts
        self.getUserId = getUserId
    }

    func viewAppear() {
        Task {
            guard let userId = getUserId() else {
                showLoginViewSubject.send(())
                return
            }
            do {
                let postItems = try await getPosts(userId)
                itemsSubject.send(postItems)
            } catch {
                showErrorViewSubject.send(())
                print(error)
            }
        }
    }
}
