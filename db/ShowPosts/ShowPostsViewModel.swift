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

    private var task: Task<Void, Error>?

    private let getPosts: (UserId) async throws -> [PostItem]
    private let getUserId: () -> Int?
    private let toggleFavoriteItem: (PostItem) throws -> Void
    init(getPosts: @escaping (UserId) async throws -> [PostItem],
         getUserId: @escaping () -> Int?,
         toggleFavorite: @escaping (PostItem) throws -> Void
    ) {
        self.getPosts = getPosts
        self.getUserId = getUserId
        self.toggleFavoriteItem = toggleFavorite
    }

    func viewAppear() {
        load()
    }

    func toggleFavorite(item: PostItem) {
        do {
            try toggleFavoriteItem(item)
        } catch {
            print("unable to toggle favorite item")
        }
        load()
    }

    private func load() {
        task?.cancel()
        task = Task {
            guard let userId = getUserId() else {
                showLoginViewSubject.send(())
                return
            }
            if Task.isCancelled { return }
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
