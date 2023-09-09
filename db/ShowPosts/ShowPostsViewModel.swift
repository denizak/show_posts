//
//  ShowPostsViewModel.swift
//  db
//
//  Created by deni zakya on 08/09/23.
//

import Foundation
import Combine

enum Filter {
    case all
    case favorite
}

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
    private var currentFilter = Filter.all

    private let getPosts: (UserId) async throws -> [PostItem]
    private let getFavoritePosts: (UserId) -> [PostItem]
    private let getUserId: () -> Int?
    private let toggleFavoriteItem: (PostItem) throws -> Void
    init(getPosts: @escaping (UserId) async throws -> [PostItem],
         getFavoritePosts: @escaping (UserId) -> [PostItem],
         getUserId: @escaping () -> Int?,
         toggleFavorite: @escaping (PostItem) throws -> Void
    ) {
        self.getPosts = getPosts
        self.getFavoritePosts = getFavoritePosts
        self.getUserId = getUserId
        self.toggleFavoriteItem = toggleFavorite
    }

    func viewAppear() {
        load()
    }

    func toggleFilter(filter: Filter) {
        currentFilter = filter
        load()
    }

    func toggleFavorite(item: PostItem) {
        do {
            try toggleFavoriteItem(item)
        } catch {
            print("unable to toggle favorite item")
        }
        loadAll()
    }

    private func load() {
        switch currentFilter {
        case .all:
            loadAll()
        case .favorite:
            loadFavorite()
        }
    }

    private func loadFavorite() {
        guard let userId = getUserId() else {
            showLoginViewSubject.send(())
            return
        }
        let posts = getFavoritePosts(userId)
        itemsSubject.send(posts)
    }

    private func loadAll() {
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
