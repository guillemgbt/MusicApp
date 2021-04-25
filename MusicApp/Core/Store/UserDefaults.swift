//
//  UserDefaults.swift
//  MusicApp
//
//  Created by Budia Tirado, Guillem on 4/25/21.
//

import Foundation

protocol UserDefaultsInterface {
    func setValue(_ value: Any?, forKey key: String)
    func value(forKey key: String) -> Any?
    func string(forKey defaultName: String) -> String?
}

extension UserDefaults: UserDefaultsInterface {}
