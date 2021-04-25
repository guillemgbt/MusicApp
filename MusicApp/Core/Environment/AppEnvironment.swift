//
//  AppEnvironment.swift
//  MusicApp
//
//  Created by Budia Tirado, Guillem on 4/23/21.
//

import Foundation

/// Dependency environment context of the application
class AppEnvironment: Environment {
    
    static let shared: Environment = AppEnvironment()
    
    /// Avoiding creating other instances of `AppEnvironment`
    private init() {}
    
    lazy var userDefaults: UserDefaultsInterface = UserDefaults.standard
    
    lazy var coreDataStack: CoreDataStack = CoreDataManager()
    
    lazy var networkClient: NetworkClient = API()
    
    lazy var credentialsManager: CredentialsManaging = CredentialsManager()
}
