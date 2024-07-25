//
// PersistentManager.swift
// Copyright (c) 2022 Logger
//
// Created by Hamed Hosseini on 12/14/22

import CoreData

/// TLDR 'Persistance Service Manager'
public final class PersistentManager {
    let baseModelFileName = "Logger"
    var container: NSPersistentContainer?

    init(bundle: Bundle) {
        do {
            try loadContainer(bundle: bundle)
        } catch {
            print(error)
        }
    }

    var context: NSManagedObjectContext? {
        guard let context = container?.viewContext else { return nil }
        context.name = "Main"
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }

    var newBgTask: NSManagedObjectContext? {
        guard let bgTask = container?.newBackgroundContext() else { return nil }
        bgTask.name = "BGTASK"
        bgTask.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return bgTask
    }

    func modelFile(bundle: Bundle) throws -> NSManagedObjectModel {
        guard let modelURL = bundle.url(forResource: baseModelFileName, withExtension: "momd") else { throw LoggerError.momdFile }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else { throw LoggerError.modelFile }
        return mom
    }

    func loadContainer(bundle: Bundle) throws {
        let container = NSPersistentContainer(name: "\(baseModelFileName)", managedObjectModel: try modelFile(bundle: bundle))
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("error load CoreData persistentstore des:\(desc) error: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        self.container = container
    }

    func delete() throws {
        let storeCordinator = container?.persistentStoreCoordinator
        guard let store = storeCordinator?.persistentStores.first, let url = store.url else { throw LoggerError.persistentStore }
        if #available(iOS 15.0, *) {
            try storeCordinator?.destroyPersistentStore(at: url, type: .sqlite)
        } else {
            try storeCordinator?.destroyPersistentStore(at: url, ofType: NSSQLiteStoreType)
        }
    }
}
