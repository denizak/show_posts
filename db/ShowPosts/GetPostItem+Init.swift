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
                try await requester.request(userId: userId).map({ $0.toPostItem() })
            },
            getFavoritePostItem: {
                favoritePostPersistent.getAll()
            },
            getUserId: {
                userStorage.get()
            })
    }
}

extension PostItemResponse {
    func toPostItem() -> PostItem {
        .init(id: id, title: title, body: body, isFavorite: false)
    }
}
