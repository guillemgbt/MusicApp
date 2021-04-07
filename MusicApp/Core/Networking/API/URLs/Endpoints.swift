//
//  Endpoints.swift
//  MovieSearch
//
//  Created by Guillem Budia Tirado on 31/03/2020.
//  Copyright © 2020 guillemgbt. All rights reserved.
//

import Foundation

/// Endpoint wrapper of the TMDb backend
struct Endpoint {
    let path: String
    var queryItems: [URLQueryItem]
    
    init(path: String, queryItems: [URLQueryItem] = []) {
        self.path = path
        self.queryItems = queryItems
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.deezer.com"
        components.path = path
        components.queryItems = queryItems

        return components.url
    }
    
    func paginated(index: Int = 0, limit: Int = 10) -> Endpoint {
        let pageItems = [URLQueryItem(name: "index", value: "\(index)"),
                          URLQueryItem(name: "limit", value: "\(limit)")]
        
        var copy = self
        copy.queryItems.append(contentsOf: pageItems)
        
        return copy
    }
    
    func authenticated(with credentialsManager: CredentialsManaging = CredentialsManager()) -> Endpoint {
        let tokenItem = URLQueryItem(name: "access_token", value: credentialsManager.accessToken)
       
        var copy = self
        copy.queryItems.append(tokenItem)
        
        return copy
    }
}
