//
// PersistentManager.swift
// Copyright (c) 2022 Logger
//
// Created by Hamed Hosseini on 12/14/22

import CoreData

/// TLDR 'Persistance Service Manager'
public final class PersistentManager {
    let baseModelFileName = "Logger"

    init() {
        loadContainer()
    }

    var context: NSManagedObjectContext? {
        guard let context = container?.viewContext else { return nil }
        context.name = "Main"
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }

    func newBgTask() -> NSManagedObjectContext? {
        guard let bgTask = container?.newBackgroundContext() else { return nil }
        bgTask.name = "BGTASK"
        bgTask.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return bgTask
    }

    lazy var modelFile: NSManagedObjectModel = {
        guard let modelURL = Bundle.moduleBundle.url(forResource: baseModelFileName, withExtension: "momd") else { fatalError("Couldn't find the mond file!") }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else { fatalError("Error initializing mom from: \(modelURL)") }
        return mom
    }()

    var container: NSPersistentContainer?

    func loadContainer() {
        let container = NSPersistentContainer(name: "\(baseModelFileName)", managedObjectModel: modelFile)
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("error load CoreData persistentstore des:\(desc) error: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        self.container = container
    }

    func delete() {
        let storeCordinator = container?.persistentStoreCoordinator
        guard let store = storeCordinator?.persistentStores.first, let url = store.url else { return }
        do {
            if #available(iOS 15.0, *) {
                try storeCordinator?.destroyPersistentStore(at: url, type: .sqlite)
            } else {
                try storeCordinator?.destroyPersistentStore(at: url, ofType: NSSQLiteStoreType)
            }
        } catch {
            print("Error to delete the database file: \(error.localizedDescription)")
        }
    }
}
