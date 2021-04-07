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
    func registerAccessToken(_ token: String)
    func fetchProfile() -> AnyPublisher<User, Error>
}

enum CredentialsManagerError: Error {
    case missingData
}

class CredentialsManager: CredentialsManaging {
    
    private enum Keys: String {
        case tokenKey
        case userIdKey
    }
    
    private let api: API
    private let coreDataManager: CoreDataManager
    
    init(api: API = API.shared, coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.api = api
        self.coreDataManager = coreDataManager
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
        return UserDefaults.standard.string(forKey: Keys.tokenKey.rawValue)
    }
    
    func registerAccessToken(_ token: String) {
        UserDefaults.standard.setValue(token, forKey: Keys.tokenKey.rawValue)
    }
    
    var userId: String? {
        return UserDefaults.standard.string(forKey: Keys.userIdKey.rawValue)
    }
    
    func fetchProfile() -> AnyPublisher<User, Error> {
        return api.GET(.profile)
            .decode(type: User.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .tryMap { [weak self] user -> User in
                try self?.coreDataManager.saveContext()
                UserDefaults.standard.setValue(user.id, forKey: Keys.userIdKey.rawValue)
                return user
            }.eraseToAnyPublisher()
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
