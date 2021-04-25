//
//  MockNetworkClient.swift
//  MusicAppTests
//
//  Created by Budia Tirado, Guillem on 4/25/21.
//

import Foundation
import Combine
@testable import MusicApp

class MockNetworkClient: NetworkClient {
    
    enum Errors: Error {
        case defaultError
    }
    
    var data: Data?
    
    func GET(_ endpoint: Endpoint, onSuccess: @escaping APISuccessResponse, onError: @escaping APIErrorResponse) -> URLSessionDataTask? {
        guard let data = data else {
            onError("Error")
            return nil
        }
        onSuccess(data)
        return nil
    }
    
    func POST(_ endpoint: Endpoint, dataDict: [String : Any], onSuccess: @escaping APISuccessResponse, onError: @escaping APIErrorResponse) -> URLSessionDataTask? {
        return GET(endpoint, onSuccess: onSuccess, onError: onError)
    }
    
    func GET(_ endpoint: Endpoint) -> AnyPublisher<Data, Error> {
        guard let data = data else {
            return Fail(error: Errors.defaultError)
                .eraseToAnyPublisher()
        }
        return Just(data)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func POST(_ endpoint: Endpoint, dataDict: [String : Any]) -> AnyPublisher<Data, Error> {
        return GET(endpoint)
    }
    
    
}
