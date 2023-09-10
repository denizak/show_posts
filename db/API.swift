//
//  API.swift
//  db
//
//  Created by Deni Zakya on 10/09/23.
//

import Foundation

struct API {
    private let scheme = "https"
    private let host = "jsonplaceholder.typicode.com"
    private let path: String
    private let queryItems: [URLQueryItem]
    init(path: String, queryItems: [URLQueryItem]) {
        self.path = path
        self.queryItems = queryItems
    }
    
    func makeURLRequest() -> URLRequest? {
        guard let url = makeURL() else { return nil }
        return URLRequest(url: url)
    }
    
    private func makeURL() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
}
