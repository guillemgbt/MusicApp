//
//  CoreDataManager.swift
//  MusicApp
//
//  Created by Budia Tirado, Guillem on 3/17/21.
//

import CoreData

protocol CoreDataStack {
    var context: NSManagedObjectContext { get }
    func saveContext() throws
    var contextJSONDecoder: JSONDecoder { get }
}

extension CodingUserInfoKey {
    static var managedObjectContext: CodingUserInfoKey {
        return CodingUserInfoKey(rawValue: "managedObjectContextKey")!
    }
}

extension CoreDataStack {
    var contextJSONDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = context
        return decoder
    }
}

enum CoreDataStackError: Error {
    case missingContext
}

final class CoreDataManager: CoreDataStack {
    
    private let modelName = "MusicApp"
    
    private(set) lazy var context: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return managedObjectContext
    }()
    
    func saveContext() throws {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                Utils.printError(sender: self, message: error.localizedDescription)
                throw error
            }
        }
    }
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"

        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)

        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: nil)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }

        return persistentStoreCoordinator
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }

        return managedObjectModel
    }()
}
