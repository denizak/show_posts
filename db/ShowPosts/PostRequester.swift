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
    private let scheme = "https"
    private let host = "jsonplaceholder.typicode.com"
    private let path = "/posts"
    private let userIdParamKey = "userId"

    private let url = "https://jsonplaceholder.typicode.com/posts?userId=1"

    func request(userId: Int) async throws -> [PostItemResponse] {
        guard let url = makeURL(items: [.init(name: userIdParamKey, value: "\(userId)")]) else { return [] }
        let urlRequest = URLRequest(url: url)

        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            return try JSONDecoder().decode([PostItemResponse].self, from: data)
        } catch {
            throw PostRequesterError.requestError(error)
        }
    }

    private func makeURL(items: [URLQueryItem]) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = items
        return urlComponents.url
    }
}
