//
//  Track.swift
//  MusicApp
//
//  Created by Budia Tirado, Guillem on 3/16/21.
//

import Foundation
import CoreData

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
    case unknownEntityType
}

class Track: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case id, title, rank, duration, link
        case audioURL = "preview"
        case explicit = "explicit_lyrics"
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw CoreDataStackError.missingContext
        }
        
        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int64.self, forKey: .id)
        self.id = id
        self.title = try container.decode(String.self, forKey: .title)
        self.rank = try container.decode(Int64.self, forKey: .rank)
        self.duration = try container.decode(Float.self, forKey: .duration)
        self.link = try container.decode(URL.self, forKey: .link)
        self.audioURL = try container.decode(URL.self, forKey: .audioURL)
        self.explicit = try container.decode(Bool.self, forKey: .explicit)
    }
}
