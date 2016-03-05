//
//  PhotoEntity.swift
//  Sherpany
//
//  Created by Balázs Kilvády on 3/5/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import Foundation
import CoreData

@objc(PhotoEntity)
class PhotoEntity: NSManagedObject {
    class func createPhotoEntity(moc: NSManagedObjectContext) -> PhotoEntity {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("PhotoEntity", inManagedObjectContext: moc) as! PhotoEntity
        return newItem
    }
}
