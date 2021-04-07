//
//  EntityType.swift
//  MusicApp
//
//  Created by Budia Tirado, Guillem on 3/16/21.
//

import Foundation

enum EntityType: String {
    case track = "track"
    case artist = "artist"
    case album = "album"
}

struct APIResponse: Decodable {
    
    let data: [CodableEntity]
    let total: Int?
    
    private enum CodingKeys: String, CodingKey {
        case data
        case total
    }
}

enum CodableEntity: Decodable {
    case track(Track)
    case artist
    case album
    
    private enum CodingKeys: String, CodingKey {
        case type
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawType = try container.decode(String.self, forKey: .type)
        
        guard let type = EntityType(rawValue: rawType) else {
            throw DecoderConfigurationError.unknownEntityType
        }
        
        switch type {
        case .track:
            let track = try Track(from: decoder)
            self = .track(track)
        case .artist:
            self = .artist
        case .album:
            self = .album
        }
    }
}
