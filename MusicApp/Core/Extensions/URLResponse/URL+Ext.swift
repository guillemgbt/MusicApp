//
//  URL+Ext.swift
//  MusicApp
//
//  Created by Budia Tirado, Guillem on 3/20/21.
//

import Foundation

extension URL {
    var replacingAnchorTag: URL? {
        URL(string: self.absoluteString.replacingOccurrences(of: "#", with: "?"))
    }
}
