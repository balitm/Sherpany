//
//  AlbumEntity.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/4/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import Foundation
import CoreData


class AlbumEntity: NSManagedObject {
    class func createAlbumEntity(moc: NSManagedObjectContext) -> AlbumEntity {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("AlbumEntity", inManagedObjectContext: moc) as! AlbumEntity
        return newItem
    }
}
