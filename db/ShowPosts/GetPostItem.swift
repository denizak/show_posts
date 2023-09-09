//
//  GetPostItem.swift
//  db
//
//  Created by deni zakya on 09/09/23.
//

import Foundation

struct GetPostItem {
    let requestPostItem: (Int) async throws -> [PostItem]
    let getFavoritePostItem: (Int) -> [PostItem]
    let getUserId: () -> Int?

    func getPosts() async throws -> [PostItem] {
        guard let userId = getUserId() else { return [] }

        let remoteItems = try await requestPostItem(userId)
        let favoriteItems = getFavoritePostItem(userId)
        let favoriteIds: Set<Int> = Set(favoriteItems.map { $0.id })
        var postItems: [PostItem] = []

        for index in remoteItems.indices {
            if favoriteIds.contains(remoteItems[index].id) {
                let item = PostItem(
                    id: remoteItems[index].id,
                    userId: userId,
                    title: remoteItems[index].title,
                    body: remoteItems[index].body,
                    isFavorite: true)
                postItems.append(item)
            } else {
                postItems.append(remoteItems[index])
            }
        }

        return postItems
    }
}
