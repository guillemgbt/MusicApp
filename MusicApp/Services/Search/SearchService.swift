//
//  SearchService.swift
//  MusicApp
//
//  Created by Budia Tirado, Guillem on 3/14/21.
//

import Foundation
import Combine

extension Endpoint {
    static func search(query: String, entity: EntityType? = nil) -> Endpoint {
        
        var path = "/search"
        if let entity = entity {
            path.append(contentsOf: "/" + entity.rawValue)
        }
        
        return Endpoint(
            path: path,
            queryItems: [
                URLQueryItem(name: "q", value: query)
            ]
        )
    }
}

protocol SearchServing {
    func search(query: String)
}

class SearchService: SearchServing {
    
    let api: API
    private var subscriptions = Set<AnyCancellable>()
    
    init(api: API = API.shared) {
        self.api = api
    }
   
    func search(query: String) /*-> AnyPublisher<[Track], Error> */ {
//        api.GET(.search(query: query, entity: .artist)) { (response) in
//            Utils.printDebug(sender: self, message: response)
//        } onError: { (error) in
//            Utils.printError(sender: self, message: error)
//        }
        
        api.GET(.search(query: "eminem", entity: .artist)).sink(receiveCompletion: { (result) in
            return
        }, receiveValue: { (data) in
            let decoder = JSONDecoder()
            let product = try? decoder.decode(APIResponse.self, from: data)
            print(data)
        }).store(in: &subscriptions)

        
        //return api.GET(.search(query: query))
    }
    
}
