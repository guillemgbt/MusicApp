//
//  TestEnvironment.swift
//  MusicAppTests
//
//  Created by Budia Tirado, Guillem on 4/25/21.
//

import Foundation
@testable import MusicApp

class TestEnvironment: Environment {
    
    init(userDefaults: UserDefaultsInterface = MockUserDefaults(),
         networkClient: NetworkClient = MockNetworkClient(),
         coreDataStack: CoreDataStack = MockCoreDataStack()) {
        
        self.userDefaults = userDefaults
        self.networkClient = networkClient
        self.coreDataStack = coreDataStack
    }
    
    var userDefaults: UserDefaultsInterface
    
    var networkClient: NetworkClient
    
    var coreDataStack: CoreDataStack
    
    lazy var credentialsManager: CredentialsManaging = CredentialsManager(environment: self)
    
    
}
