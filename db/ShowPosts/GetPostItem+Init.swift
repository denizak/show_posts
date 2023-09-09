//
//  GetPostItem+Init.swift
//  db
//
//  Created by deni zakya on 09/09/23.
//

import Foundation

extension GetPostItem {
    static func make() -> GetPostItem {
        let requester = PostRequester()
        let favoritePostPersistent = FavoritePostPersistent.shared
        let userStorage = UserIdStorage.shared
        return GetPostItem(
            requestPostItem: { userId in
                try await requester.request(userId: userId).map({ $0.toPostItem(userId: userId) })
            },
            getFavoritePostItem: { userId in
                favoritePostPersistent.getAll(userId: userId)
            },
            getUserId: {
                userStorage.get()
            })
    }
}

extension PostItemResponse {
    func toPostItem(userId: Int) -> PostItem {
        .init(id: id, userId: userId, title: title, body: body, isFavorite: false)
    }
}
