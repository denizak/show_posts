//
//  ShowPostsViewModel+Init.swift
//  db
//
//  Created by deni zakya on 09/09/23.
//

import Foundation

extension ShowPostsViewModel {
    static func make() -> ShowPostsViewModel {
        let requester = PostRequester()
        return .init(
            getPosts: { userId in try await requester.request(userId: userId).map { $0.toPostItem() }
            },
            getUserId: { 1 })
    }
}

extension PostItemResponse {
    func toPostItem() -> PostItem {
        .init(id: id, title: title, body: body)
    }
}
