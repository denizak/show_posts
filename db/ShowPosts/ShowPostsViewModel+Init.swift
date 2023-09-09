//
//  ShowPostsViewModel+Init.swift
//  db
//
//  Created by deni zakya on 09/09/23.
//

import Foundation

extension ShowPostsViewModel {
    static func make() -> ShowPostsViewModel {
        let getPostItem = GetPostItem.make()
        let userStorage = UserIdStorage.shared
        let favoritePostPersistent = FavoritePostPersistent.shared
        return .init(
            getPosts: { userId in
                try await getPostItem.getPosts()
            },
            getFavoritePosts: { userId in
                favoritePostPersistent.getAll(userId: userId)
            },
            getUserId: { userStorage.get() },
            toggleFavorite: { item in
                try favoritePostPersistent.togglePostItem(item: item)
            })
    }
}
