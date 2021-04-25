//
//  CredentialsManager.swift
//  MusicApp
//
//  Created by Budia Tirado, Guillem on 3/20/21.
//

import Foundation
import Combine
import CoreData


protocol CredentialsManaging {
    var loginPageURL: URL { get }
    var accessToken: String? { get }
    var userId: String? { get }
    func registerAccessToken(_ token: String)
    func fetchProfile() -> AnyPublisher<User, Error>
    func getUser() -> AnyPublisher<User, Error>
    var currentUser: User? { get }
}

enum CredentialsManagerError: Error {
    case missingData
}

class CredentialsManager: CredentialsManaging {
    
    private enum Keys: String {
        case tokenKey
        case userIdKey
    }
    
    private let networkClient: NetworkClient
    private let coreDataManager: CoreDataStack
    private let userDefaults: UserDefaultsInterface
    
    init(environment: Environment = AppEnvironment.shared) {
        self.networkClient = environment.networkClient
        self.coreDataManager = environment.coreDataStack
        self.userDefaults = environment.userDefaults
    }
    
    var loginPageURL: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "connect.deezer.com"
        components.path = "/oauth/auth.php"
        components.queryItems = loginPageQueryItems
        return components.url!
    }
    
    private var loginPageQueryItems: [URLQueryItem] {
        return [
            URLQueryItem(name: "app_id", value: AppInfo.deezerId),
            URLQueryItem(name: "redirect_uri", value: AppInfo.deezerRedirectURL),
            URLQueryItem(name: "perms", value: "basic_access,email,offline_access,manage_library,manage_community,delete_library,listening_history"),
            URLQueryItem(name: "response_type", value: "token")
        ]
    }
    
    @Published var isSignedIn: Bool = false
    
    var accessToken: String? {
        return userDefaults.string(forKey: Keys.tokenKey.rawValue)
    }
    
    func registerAccessToken(_ token: String) {
        userDefaults.setValue(token, forKey: Keys.tokenKey.rawValue)
    }
    
    var userId: String? {
        return userDefaults.string(forKey: Keys.userIdKey.rawValue)
    }
    
    // https://www.donnywals.com/implementing-a-one-way-sync-strategy-with-core-data-urlsession-and-combine/
    
    func fetchProfile() -> AnyPublisher<User, Error> {
        return networkClient.GET(.profile)
            .receive(on: DispatchQueue.main)
            .decode(type: User.self, decoder: coreDataManager.contextJSONDecoder)
            .flatMap({ [weak self] user -> AnyPublisher<User, Error> in
                self?.userDefaults.setValue(user.id, forKey: Keys.userIdKey.rawValue)
                try? self?.coreDataManager.saveContext()
                return self?.getUser() ??
                    Fail(error: CredentialsManagerError.missingData).eraseToAnyPublisher()
            }).eraseToAnyPublisher()
    }
    
    func getUser() -> AnyPublisher<User, Error> {
        
        return Future<User, Error> { [weak self] (promise) in
            
            guard let userId = self?.userId,
                  let context = self?.coreDataManager.context
            else {
                promise(.failure(CredentialsManagerError.missingData))
                return
            }
            
            context.perform {
                let request: NSFetchRequest = User.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", userId)
                
                do {
                    guard let user = try request.execute().first else {
                        promise(.failure(CredentialsManagerError.missingData))
                        return
                    }
                    promise(.success(user))
                } catch let error {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    var currentUser: User? {
        guard let userId = userId else {
            return nil
        }
        
        var user: User?
        let context = coreDataManager.context
        context.performAndWait {
            let request: NSFetchRequest = User.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", userId)
            user = try? request.execute().first
        }
        
        return user
    }
    
}

extension Endpoint {
    static var profile: Endpoint {
        return Endpoint(path: "/user/me").authenticated()
    }
}
