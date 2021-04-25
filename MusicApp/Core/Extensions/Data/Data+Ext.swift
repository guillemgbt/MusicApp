//
//  Data+Ext.swift
//  MusicApp
//
//  Created by Budia Tirado, Guillem on 4/25/21.
//

import Foundation

extension Data {
    
    var json: [String: Any]? {
        try? JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
    }
    
}

