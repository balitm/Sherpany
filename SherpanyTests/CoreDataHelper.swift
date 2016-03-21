//
//  CoreDataHelper.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/4/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import CoreData

class CoreDataHelper {

    var storeCoordinator: NSPersistentStoreCoordinator!
    var managedObjectContext: NSManagedObjectContext!
    var managedObjectModel: NSManagedObjectModel!
    var store: NSPersistentStore!

    func setUpInMemoryManagedObjectContext() {
        let bundle = NSBundle(forClass: CoreDataHelper.self)
        let url = bundle.URLForResource("Sherpany", withExtension: "momd");
        managedObjectModel = NSManagedObjectModel(contentsOfURL: url!)!

        storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        store = try? storeCoordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)

        managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = storeCoordinator
    }

    func releaseMemoryManagedObjectContext() -> Bool {
        managedObjectContext = nil
        var ret = true;

        do {
            try storeCoordinator.removePersistentStore(store)
        } catch {
            print("couldn't remove persistant store: \(error)")
            ret = false
        }
        return ret
    }
}
