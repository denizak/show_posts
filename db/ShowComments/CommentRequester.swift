//
//  CommentRequester.swift
//  db
//
//  Created by Deni Zakya on 10/09/23.
//

import Foundation

struct CommentItemResponse: Decodable {
    let id: Int
    let postId: Int
    let name: String
    let email: String
    let body: String
}

enum CommentRequesterError: Error {
    case requestError(Error)
}

struct CommentRequester {
    private let path = "/comments"
    private let postIdParamKey = "postId"
    
    func request(postId: Int) async throws -> [CommentItemResponse] {
        let api = API(path: path, queryItems: [.init(name: postIdParamKey, value: "\(postId)")])
        guard let urlRequest = api.makeURLRequest() else { return [] }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            return try JSONDecoder().decode([CommentItemResponse].self, from: data)
        } catch {
            throw CommentRequesterError.requestError(error)
        }
    }
}
