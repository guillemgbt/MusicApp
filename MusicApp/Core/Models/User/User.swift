//
//  User.swift
//  MusicApp
//
//  Created by Budia Tirado, Guillem on 3/20/21.
//

import Foundation
import CoreData

class User: NSManagedObject, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, status, picture, country
        case inscriptionDate = "inscription_date"
        case language = "lang"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init(context: CoreDataManager.shared.context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int64.self, forKey: .id)
        self.id = id
        self.name = try container.decode(String.self, forKey: .name)
        self.email = try container.decode(String.self, forKey: .email)
        self.status = try container.decode(Int64.self, forKey: .status)
        self.picture = try container.decode(String.self, forKey: .picture)
        self.country = try container.decode(String.self, forKey: .country)
        self.inscriptionDate = try container.decode(String.self, forKey: .inscriptionDate)
        self.language = try container.decode(String.self, forKey: .language)
    }
}
