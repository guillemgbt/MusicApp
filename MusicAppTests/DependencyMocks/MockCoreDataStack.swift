//
//  MockCoreDataStack.swift
//  MusicAppTests
//
//  Created by Budia Tirado, Guillem on 4/23/21.
//

import Foundation
import CoreData
@testable import MusicApp

class MockCoreDataStack: CoreDataStack {
    
    private let modelName = "MusicApp"
    
    private(set) lazy var context: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
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
        

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentStoreCoordinator.addPersistentStore(with: description) { (_, error) in
            guard error == nil else {
                fatalError()
            }
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
