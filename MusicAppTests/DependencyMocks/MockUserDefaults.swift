//
//  MockUserDefaults.swift
//  MusicAppTests
//
//  Created by Budia Tirado, Guillem on 4/25/21.
//

import Foundation
@testable import MusicApp

class MockUserDefaults: UserDefaultsInterface {
    
    private var store = [String:Any]()
    
    func setValue(_ value: Any?, forKey key: String) {
        store[key] = value
    }
    
    func value(forKey key: String) -> Any? {
        return store[key]
    }
    
    func string(forKey defaultName: String) -> String? {
        return store[defaultName] as? String
    }
    
}
