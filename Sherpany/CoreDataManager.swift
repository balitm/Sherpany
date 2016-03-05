//
//  CoreDataManager.swift
//  Creative
//
//  Created by Balázs Kilvády on 15/05/15.
//  Copyright (c) 2015 kil-dev. All rights reserved.
//

import Foundation
import CoreData


class CoreDataManager {
    static private var _instance: CoreDataManager!

    let managedContext: NSManagedObjectContext

    class var instance: CoreDataManager {
        return _instance
    }

    class func initialize(context: NSManagedObjectContext) {
        _instance = CoreDataManager(context: context)
    }

    private init(context: NSManagedObjectContext) {
        managedContext = context
    }

    func saveContext() {
        let moc = self.managedContext
        if moc.hasChanges {
            do {
                try moc.save()
            } catch let error as NSError {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
    }


    // MARK: methods

    func createUserEntity(data: UserData) -> UserEntity {
        let user = UserEntity.createUserEntity(managedContext)
        user.userId = data.userId
        user.name = data.name
        user.email = data.email
        user.catchPhrase = data.catchPhrase
        return user
    }

    func createAlbumEntity(data: AlbumData) -> AlbumEntity {
        let album = AlbumEntity.createAlbumEntity(managedContext)
        album.albumId = data.albumId
        album.userId = data.userId
        album.title = data.title
        return album
    }

    func createPhotoEntity(data: PhotoData) -> PhotoEntity {
        let photo = PhotoEntity.createPhotoEntity(managedContext)
        photo.photoId = data.photoId
        photo.albumId = data.albumId
        photo.title = data.title
        photo.thumbnailUrl = data.thumbnailUrl
        return photo
    }

    func isEmpty(entityName: String) -> Bool {
        let request = NSFetchRequest(entityName: entityName)
        return managedContext.countForFetchRequest(request, error: nil) == 0
    }

//    func fetch(name: String) -> Pattern? {
//        let request = NSFetchRequest(entityName: "Pattern")
//        request.predicate = NSPredicate(format: "name = %@", argumentArray: [name])
//        do {
//            let entities = try managedContext.executeFetchRequest(request)
//            assert(entities.count <= 1, "Not unique.")
//            if entities.count == 1 {
//                return entities.last as? Pattern
//            }
//        } catch {
//
//        }
//        return nil
//    }
//
//    func delete(object: NSManagedObject) {
//        managedContext.deleteObject(object)
//    }

//    func delete(entity: String, index: Int) -> Bool {
//        var data = fetch(entity)
//        if data != nil {
//            managedContext.deleteObject(data![index])
//            data!.removeAtIndex(index)
//            managedContext.save(nil)
//            return true
//        }
//
//        return false
//    }
//
//    func fetch(entity: String) -> [NSManagedObject]? {
//        var request = NSFetchRequest(entityName: entity)
//        var error: NSError?
//        if let entities = managedContext.executeFetchRequest(request, error: &error) as? [NSManagedObject] {
//            if entities.count > 0 {
//                return entities
//            }
//        }
//        return nil
//    }
//
//    func save(entity: String, _ attributes: [String: AnyObject]) -> NSManagedObject? {
//        var entity = NSEntityDescription.entityForName(entity, inManagedObjectContext: managedContext)
//        let object = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.managedContext)
//
//        for (key, attr) in attributes {
//            object.setValue(attr, forKey: key)
//        }
//
//        var error: NSError?
//
//        if !managedContext.save(&error) {
//            return nil
//        }
//        
//        return object
//    }
}
