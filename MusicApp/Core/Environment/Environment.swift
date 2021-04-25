//
//  Environment.swift
//  MusicApp
//
//  Created by Budia Tirado, Guillem on 4/23/21.
//

import Foundation

/// Interface for the dependency environment context of the application
protocol Environment {
    
    var userDefaults: UserDefaultsInterface { get }
    
    var networkClient: NetworkClient { get }
    
    var coreDataStack: CoreDataStack { get }
    
    var credentialsManager: CredentialsManaging { get }
}
