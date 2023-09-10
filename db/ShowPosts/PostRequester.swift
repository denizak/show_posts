//
//  PostRequester.swift
//  db
//
//  Created by deni zakya on 08/09/23.
//

import Foundation

struct PostItemResponse: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

enum PostRequesterError: Error {
    case requestError(Error)
}

struct PostRequester {
    private let path = "/posts"
    private let userIdParamKey = "userId"

    func request(userId: Int) async throws -> [PostItemResponse] {
        let api = API(path: path, queryItems: [.init(name: userIdParamKey, value: "\(userId)")])
        guard let urlRequest = api.makeURLRequest() else { return [] }

        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            return try JSONDecoder().decode([PostItemResponse].self, from: data)
        } catch {
            throw PostRequesterError.requestError(error)
        }
    }
}
